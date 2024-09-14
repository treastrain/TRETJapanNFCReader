//
//  NFCNativeTagReaderViewModifier.swift
//  NativeTag
//
//  Created by treastrain on 2023/01/23.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import Combine
public import SwiftUI

public struct NFCNativeTagReaderViewModifier: @unchecked Sendable {
    private var isPresented: Binding<Bool>
    private let pollingOption: NFCTagReaderSession.PollingOption
    private let taskPriority: TaskPriority?
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (any Error) -> Void
    private let didBecomeActive: @Sendable (Object.TagType.Reader.AfterBeginProtocol) async -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetect: @Sendable (Object.TagType.ReaderProtocol, Object.TagType.ReaderDetectObject) async throws -> Object.TagType.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        pollingOption: NFCTagReaderSession.PollingOption,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: any Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: NativeTag.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) {
        self.isPresented = isPresented
        self.pollingOption = pollingOption
        self.taskPriority = taskPriority
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
    }
}

extension NFCNativeTagReaderViewModifier {
    private final class Object: @unchecked Sendable {
        typealias TagType = NativeTag
        private var reader: NFCReader<TagType>?
        private var currentTask: Task<(), Never>?
        
        func read(pollingOption: NFCTagReaderSession.PollingOption, taskPriority: TaskPriority?, detectingAlertMessage: String, onBeginReadingError: @escaping @Sendable (any Error) -> Void, didBecomeActive: @escaping @Sendable (TagType.Reader.AfterBeginProtocol) async -> Void, didInvalidate: @escaping @Sendable (NFCReaderError) -> Void, didDetect: @escaping @Sendable (TagType.ReaderProtocol, _ tags: TagType.ReaderDetectObject) async throws -> TagType.DetectResult) {
            cancel()
            currentTask = Task {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
                            pollingOption: pollingOption,
                            taskPriority: taskPriority,
                            detectingAlertMessage: detectingAlertMessage,
                            didBecomeActive: didBecomeActive,
                            didInvalidate: didInvalidate,
                            didDetect: didDetect
                        )
                    } catch {
                        onBeginReadingError(error)
                        reader = nil
                    }
                } onCancel: {
                    reader = nil
                }
            }
        }
        
        func cancel() {
            Task {
                await reader?.invalidate()
            }
            currentTask?.cancel()
            currentTask = nil
        }
    }
}

extension NFCNativeTagReaderViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .onChange(of: isPresented.wrappedValue, perform: action(_:))
        } else {
            content
                .onReceive(Just(isPresented.wrappedValue), perform: action(_:))
        }
    }
    
    private func action(_ flag: Bool) {
        if flag {
            object.read(
                pollingOption: pollingOption,
                taskPriority: taskPriority,
                detectingAlertMessage: detectingAlertMessage,
                onBeginReadingError: {
                    isPresented.wrappedValue = false
                    onBeginReadingError($0)
                },
                didBecomeActive: didBecomeActive,
                didInvalidate: {
                    isPresented.wrappedValue = false
                    didInvalidate($0)
                },
                didDetect: didDetect
            )
        } else {
            object.cancel()
        }
    }
}

extension View {
    public func nfcNativeTagReader(
        isPresented: Binding<Bool>,
        pollingOption: NFCTagReaderSession.PollingOption,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: any Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: NativeTag.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) -> some View {
        modifier(
            NFCNativeTagReaderViewModifier(
                isPresented: isPresented,
                pollingOption: pollingOption,
                taskPriority: taskPriority,
                detectingAlertMessage: detectingAlertMessage,
                onBeginReadingError: onBeginReadingError,
                didBecomeActive: didBecomeActive,
                didInvalidate: didInvalidate,
                didDetect: didDetect
            )
        )
    }
}
#endif
