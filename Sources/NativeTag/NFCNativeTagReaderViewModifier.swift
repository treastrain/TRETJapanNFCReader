//
//  NFCNativeTagReaderViewModifier.swift
//  NativeTag
//
//  Created by treastrain on 2023/01/23.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
import Combine
import SwiftUI

public struct NFCNativeTagReaderViewModifier: @unchecked Sendable {
    private var isPresented: Binding<Bool>
    private let pollingOption: NFCTagReaderSession.PollingOption
    private let detectingAlertMessage: String
    private let onBeginReadingError: @Sendable (Error) -> Void
    private let didBecomeActive: @Sendable (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void
    private let didInvalidate: @Sendable (NFCReaderError) -> Void
    private let didDetect: @Sendable (_ session: NativeTag.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    
    private let object = Object()
    
    public init(
        isPresented: Binding<Bool>,
        pollingOption: NFCTagReaderSession.PollingOption,
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_ session: NativeTag.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    ) {
        self.isPresented = isPresented
        self.pollingOption = pollingOption
        self.detectingAlertMessage = detectingAlertMessage
        self.onBeginReadingError = onBeginReadingError
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
    }
}

extension NFCNativeTagReaderViewModifier {
    private final class Object: @unchecked Sendable {
        private var reader: NFCReader<NativeTag>?
        private var currentTask: Task<(), Never>?
        
        func read(pollingOption: NFCTagReaderSession.PollingOption, detectingAlertMessage: String, onBeginReadingError: @Sendable @escaping (Error) -> Void, didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void, didInvalidate: @Sendable @escaping (NFCReaderError) -> Void, didDetect: @Sendable @escaping (_ session: NativeTag.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult) {
            cancel()
            currentTask = Task {
                await withTaskCancellationHandler {
                    reader = .init()
                    do {
                        try await reader?.read(
                            pollingOption: pollingOption,
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
        detectingAlertMessage: String,
        onBeginReadingError: @Sendable @escaping (Error) -> Void,
        didBecomeActive: @Sendable @escaping (_ session: NativeTag.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_ session: NativeTag.ReaderSessionProtocol, _ tags: NativeTag.ReaderSessionDetectObject) async throws -> NativeTag.DetectResult
    ) -> some View {
        modifier(
            NFCNativeTagReaderViewModifier(
                isPresented: isPresented,
                pollingOption: pollingOption,
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