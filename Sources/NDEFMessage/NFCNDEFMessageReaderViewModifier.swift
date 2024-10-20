//
//  NFCNDEFMessageReaderViewModifier.swift
//  NDEFMessage
//
//  Created by treastrain on 2023/01/22.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
public import SwiftUI

@available(iOS 15.0, *)
private struct NFCNDEFMessageReaderViewModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let invalidateAfterFirstRead: Bool
    private let taskPriority: TaskPriority
    private let detectingAlertMessage: String
    private let terminatingAlertMessage: @Sendable () -> String
    private let onDidBecomeActive: @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession) async -> Void
    private let onDidDetect: @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession, _ messages: NFCNDEFReaderSession.DetectedMessages) async -> Void
    private let onDidInvalidate: @Sendable (_ error: any Error) -> Void
    
    init(
        isPresented: Binding<Bool>,
        invalidateAfterFirstRead: Bool,
        taskPriority: TaskPriority,
        detectingAlertMessage: String,
        terminatingAlertMessage: @escaping @Sendable () -> String,
        onDidBecomeActive: @escaping @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession) async -> Void,
        onDidDetect: @escaping @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession, _ messages: NFCNDEFReaderSession.DetectedMessages) async -> Void,
        onDidInvalidate: @escaping @Sendable (_ error: any Error) -> Void
    ) {
        self._isPresented = isPresented
        self.invalidateAfterFirstRead = invalidateAfterFirstRead
        self.taskPriority = taskPriority
        self.detectingAlertMessage = detectingAlertMessage
        self.terminatingAlertMessage = terminatingAlertMessage
        self.onDidBecomeActive = onDidBecomeActive
        self.onDidDetect = onDidDetect
        self.onDidInvalidate = onDidInvalidate
    }
    
    @State private var readerSession: NFCNDEFReaderSession?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) {
                readerSession = $0 ? NFCNDEFReaderSession(of: .messages, invalidateAfterFirstRead: invalidateAfterFirstRead) : nil
            }
            .task(
                id: readerSession == nil,
                priority: taskPriority
            ) {
                defer {
                    readerSession = nil
                    isPresented = false
                }
                guard let readerSession else { return }
                guard NFCNDEFReaderSession.readingAvailable else {
                    onDidInvalidate(NFCReaderError(.readerErrorUnsupportedFeature))
                    return
                }
                readerSession.alertMessage = detectingAlertMessage
                let invalidator = NFCReaderSessionInvalidator(readerSession)
                await withTaskCancellationHandler(
                    operation: {
                        for await event in readerSession.messageEventStream {
                            switch event {
                            case .sessionBecomeActive:
                                await onDidBecomeActive(readerSession)
                            case .sessionDetected(let messages):
                                await onDidDetect(readerSession, messages)
                            case .sessionInvalidated(let reason):
                                onDidInvalidate(reason)
                            }
                        }
                    },
                    onCancel: {
                        invalidator.invalidate(errorMessage: terminatingAlertMessage())
                        onDidInvalidate(CancellationError())
                    }
                )
            }
    }
}

@available(iOS 15.0, *)
extension View {
    public func nfcNDEFMessageReader(
        isPresented: Binding<Bool>,
        invalidateAfterFirstRead: Bool,
        taskPriority: TaskPriority = .userInitiated,
        detectingAlertMessage: String,
        terminatingAlertMessage: @autoclosure @escaping @Sendable () -> String = "",
        onDidBecomeActive: @escaping @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession) async -> Void = { _ in },
        onDidDetect: @escaping @MainActor @Sendable (_ readerSession: NFCNDEFReaderSession, _ messages: NFCNDEFReaderSession.DetectedMessages) async -> Void,
        onDidInvalidate: @escaping @Sendable (_ error: any Error) -> Void = { _ in }
    ) -> some View {
        modifier(
            NFCNDEFMessageReaderViewModifier(
                isPresented: isPresented,
                invalidateAfterFirstRead: invalidateAfterFirstRead,
                taskPriority: taskPriority,
                detectingAlertMessage: detectingAlertMessage,
                terminatingAlertMessage: terminatingAlertMessage,
                onDidBecomeActive: onDidBecomeActive,
                onDidDetect: onDidDetect,
                onDidInvalidate: onDidInvalidate
            )
        )
    }
}
#endif
