//
//  NFCNDEFTagReaderViewModifier.swift
//  NDEFTag
//
//  Created by treastrain on 2023/01/22.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import Combine
import SwiftUI

public struct NFCNDEFTagReaderViewModifier: @unchecked Sendable {
    private var isPresented: Binding<Bool>
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (Error) -> Void
    private let didBecomeActive: @Sendable (NDEFTag.ReaderSession.AfterBeginProtocol) -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetectNDEFs: @Sendable (NDEFTag.ReaderSessionProtocol, NDEFTag.ReaderSessionDetectObject) async throws -> NDEFTag.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (NDEFTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetectNDEFs: @Sendable @escaping (NDEFTag.ReaderSessionProtocol, NDEFTag.ReaderSessionDetectObject) async throws -> NDEFTag.DetectResult
    ) {
        self.isPresented = isPresented
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetectNDEFs = didDetectNDEFs
    }
}

extension NFCNDEFTagReaderViewModifier {
    private final class Object: @unchecked Sendable {
        private var reader: NFCReader<NDEFTag>?
        private var currentTask: Task<(), Never>?
        
        func read(detectingAlertMessage: String, onBeginReadingError: @Sendable @escaping (Error) -> Void, didBecomeActive: @Sendable @escaping (NDEFTag.ReaderSession.AfterBeginProtocol) -> Void, didInvalidate: @Sendable @escaping (NFCReaderError) -> Void, didDetectNDEFs: @Sendable @escaping (NDEFTag.ReaderSessionProtocol, NDEFTag.ReaderSessionDetectObject) async throws -> NDEFTag.DetectResult) {
            cancel()
            currentTask = Task {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
                            detectingAlertMessage: detectingAlertMessage,
                            didBecomeActive: didBecomeActive,
                            didInvalidate: didInvalidate,
                            didDetect: didDetectNDEFs
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

extension NFCNDEFTagReaderViewModifier: ViewModifier {
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
                didDetectNDEFs: didDetectNDEFs
            )
        } else {
            object.cancel()
        }
    }
}

extension View {
    public func nfcNDEFTagReader(
        isPresented: Binding<Bool>,
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (NDEFTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetectNDEFs: @Sendable @escaping (NDEFTag.ReaderSessionProtocol, NDEFTag.ReaderSessionDetectObject) async throws -> NDEFTag.DetectResult
    ) -> some View {
        modifier(
            NFCNDEFTagReaderViewModifier(
                isPresented: isPresented,
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
