//
//  ISO15693TagReaderViewModifier.swift
//  ISO15693
//
//  Created by treastrain on 2023/01/26.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import Combine
import SwiftUI

public struct ISO15693TagReaderViewModifier: @unchecked Sendable {
    private var isPresented: Binding<Bool>
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (Error) -> Void
    private let didBecomeActive: @Sendable (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetect: @Sendable (_ session: ISO15693TagReader.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_ session: ISO15693TagReader.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    ) {
        self.isPresented = isPresented
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
    }
}

extension ISO15693TagReaderViewModifier {
    private final class Object: @unchecked Sendable {
        private var reader: ISO15693TagReader?
        private var currentTask: Task<(), Never>?
        
        func read(detectingAlertMessage: String, onBeginReadingError: @Sendable @escaping (Error) -> Void, didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void, didInvalidate: @Sendable @escaping (NFCReaderError) -> Void, didDetect: @Sendable @escaping (_ session: ISO15693TagReader.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult) {
            cancel()
            currentTask = Task {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
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

extension ISO15693TagReaderViewModifier: ViewModifier {
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
    public func iso15693TagReader(
        isPresented: Binding<Bool>,
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_ session: ISO15693TagReader.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    ) -> some View {
        modifier(
            ISO15693TagReaderViewModifier(
                isPresented: isPresented,
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
