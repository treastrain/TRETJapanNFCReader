//
//  NativeTagReaderViewModifier.swift
//  NativeTag
//
//  Created by treastrain on 2023/05/04.
//

#if canImport(CoreNFC) && canImport(SwiftUI)
import Combine
import SwiftUI

public protocol NativeTagReaderProtocol {
    associatedtype ReaderProtocol
    init()
    func read(
        taskPriority: TaskPriority?,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void,
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void,
        didDetect: @escaping @Sendable (_ reader: ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) async throws
    func invalidate() async
}

public struct NativeTagReaderViewModifier<Reader: NativeTagReaderProtocol> {
    private var isPresented: Binding<Bool>
    private let taskPriority: TaskPriority?
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (Error) -> Void
    private let didBecomeActive: @Sendable (Object.TagType.Reader.AfterBeginProtocol) async -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetect: @Sendable (Reader.ReaderProtocol, Object.TagType.ReaderDetectObject) async throws -> Object.TagType.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: Reader.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult
    ) {
        self.isPresented = isPresented
        self.taskPriority = taskPriority
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
    }
}

extension NativeTagReaderViewModifier {
    private final class Object {
        typealias TagType = NativeTag
        private var reader: Reader?
        private var currentTask: Task<(), Never>?
        
        func read(taskPriority: TaskPriority?, detectingAlertMessage: String, onBeginReadingError: @escaping @Sendable (Error) -> Void, didBecomeActive: @escaping @Sendable (_ reader: NativeTag.Reader.AfterBeginProtocol) async -> Void, didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void, didDetect: @escaping @Sendable (_ reader: Reader.ReaderProtocol, _ tags: NativeTag.ReaderDetectObject) async throws -> NativeTag.DetectResult) {
            cancel()
            currentTask = Task(priority: taskPriority) {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
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

extension NativeTagReaderViewModifier: ViewModifier {
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
#endif
