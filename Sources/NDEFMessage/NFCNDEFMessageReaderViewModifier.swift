//
//  NFCNDEFMessageReaderViewModifier.swift
//  NDEFMessage
//
//  Created by treastrain on 2023/01/22.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import Combine
import SwiftUI

public struct NFCNDEFMessageReaderViewModifier: @unchecked Sendable {
    private var isPresented: Binding<Bool>
    private let invalidateAfterFirstRead: Bool
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (Error) -> Void
    private let didBecomeActive: @Sendable (Object.TagType.Reader.AfterBeginProtocol) async -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetectNDEFs: @Sendable (Object.TagType.Reader.AfterDetectProtocol, Object.TagType.ReaderDetectObject) async -> Object.TagType.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NDEFMessage.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ reader: NDEFMessage.Reader.AfterDetectProtocol, _ messages: NDEFMessage.ReaderDetectObject) async -> NDEFMessage.DetectResult
    ) {
        self.isPresented = isPresented
        self.invalidateAfterFirstRead = invalidateAfterFirstRead
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetectNDEFs = didDetectNDEFs
    }
}

extension NFCNDEFMessageReaderViewModifier {
    private final class Object: @unchecked Sendable {
        typealias TagType = NDEFMessage
        private var reader: NFCReader<TagType>?
        private var currentTask: Task<(), Never>?
        
        func read(invalidateAfterFirstRead: Bool, detectingAlertMessage: String, onBeginReadingError: @escaping @Sendable (Error) -> Void, didBecomeActive: @escaping @Sendable (TagType.Reader.AfterBeginProtocol) async -> Void, didInvalidate: @escaping @Sendable (NFCReaderError) -> Void, didDetectNDEFs: @escaping @Sendable (TagType.Reader.AfterDetectProtocol, TagType.ReaderDetectObject) async -> TagType.DetectResult) {
            cancel()
            currentTask = Task {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
                            invalidateAfterFirstRead: invalidateAfterFirstRead,
                            detectingAlertMessage: detectingAlertMessage,
                            didBecomeActive: didBecomeActive,
                            didInvalidate: didInvalidate,
                            didDetectNDEFs: didDetectNDEFs
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

extension NFCNDEFMessageReaderViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content
                .onChange(of: isPresented.wrappedValue, perform: action(_:))
        } else {
            content
                .onReceive(Just(isPresented.wrappedValue), perform: action(_:))
        }
    }

    func action(_ flag: Bool) {
        if flag {
            object.read(
                invalidateAfterFirstRead: invalidateAfterFirstRead,
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
                didDetectNDEFs: didDetectNDEFs
            )
        } else {
            object.cancel()
        }
    }
}

extension View {
    public func nfcNDEFMessageReader(
        isPresented: Binding<Bool>,
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        onBeginReadingError: @escaping @Sendable (_ error: Error) -> Void = { _ in },
        didBecomeActive: @escaping @Sendable (_ reader: NDEFMessage.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ reader: NDEFMessage.Reader.AfterDetectProtocol, _ messages: NDEFMessage.ReaderDetectObject) async -> NDEFMessage.DetectResult
    ) -> some View {
        modifier(
            NFCNDEFMessageReaderViewModifier(
                isPresented: isPresented,
                invalidateAfterFirstRead: invalidateAfterFirstRead,
                detectingAlertMessage: detectingAlertMessage,
                onBeginReadingError: onBeginReadingError,
                didBecomeActive: didBecomeActive,
                didInvalidate: didInvalidate,
                didDetectNDEFs: didDetectNDEFs
            )
        )
    }
}
#endif
