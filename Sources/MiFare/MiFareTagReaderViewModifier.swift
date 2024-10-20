//
//  MiFareTagReaderViewModifier.swift
//  MiFare
//
//  Created by treastrain on 2023/01/26.
//

#if canImport(SwiftUI) && canImport(CoreNFC)
public import SwiftUI

@available(iOS 15.0, *)
private struct MiFareTagReaderViewModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let taskPriority: TaskPriority
    private let detectingAlertMessage: String
    private let terminatingAlertMessage: @Sendable () -> String
    private let onDidBecomeActive: @MainActor @Sendable (_ readerSession: NFCTagReaderSession) async -> Void
    private let onDidDetect: @MainActor @Sendable (_ readerSession: NFCTagReaderSession, _ tags: NFCTagReaderSession.Event.DetectedTags) async -> Void
    private let onDidInvalidate: @Sendable (_ error: any Error) -> Void
    
    init(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority,
        detectingAlertMessage: String,
        terminatingAlertMessage: @escaping @Sendable () -> String,
        onDidBecomeActive: @escaping @MainActor @Sendable (NFCTagReaderSession) async -> Void,
        onDidDetect: @escaping @MainActor @Sendable (NFCTagReaderSession, NFCTagReaderSession.Event.DetectedTags) async -> Void,
        onDidInvalidate: @escaping @Sendable (any Error) -> Void
    ) {
        self._isPresented = isPresented
        self.taskPriority = taskPriority
        self.detectingAlertMessage = detectingAlertMessage
        self.terminatingAlertMessage = terminatingAlertMessage
        self.onDidBecomeActive = onDidBecomeActive
        self.onDidDetect = onDidDetect
        self.onDidInvalidate = onDidInvalidate
    }
    
    @State private var readerSession: NFCTagReaderSession?
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) {
                readerSession = $0 ? NFCTagReaderSession(pollingOption: .iso14443) : nil
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
                guard NFCTagReaderSession.readingAvailable else {
                    onDidInvalidate(NFCReaderError(.readerErrorUnsupportedFeature))
                    return
                }
                readerSession.alertMessage = detectingAlertMessage
                let invalidator = NFCReaderSessionInvalidator(readerSession)
                await withTaskCancellationHandler(
                    operation: {
                        for await event in readerSession.eventStream {
                            switch event {
                            case .sessionBecomeActive:
                                await onDidBecomeActive(readerSession)
                            case .sessionDetected(let tags):
                                await onDidDetect(readerSession, tags)
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
    public func miFareTagReader(
        isPresented: Binding<Bool>,
        taskPriority: TaskPriority = .userInitiated,
        detectingAlertMessage: String,
        terminatingAlertMessage: @autoclosure @escaping @Sendable () -> String = "",
        onDidBecomeActive: @escaping @MainActor @Sendable (_ readerSession: NFCTagReaderSession) async -> Void = { _ in },
        onDidDetect: @escaping @MainActor @Sendable (_ readerSession: NFCTagReaderSession, _ tags: NFCTagReaderSession.Event.DetectedTags) async -> Void,
        onDidInvalidate: @escaping @Sendable (_ error: any Error) -> Void = { _ in }
    ) -> some View {
        modifier(
            MiFareTagReaderViewModifier(
                isPresented: isPresented,
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
