//
//  NFCReader+NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/24.
//

@_spi(TaskPriorityToDispatchQoSClass) import TRETNFCKit_Core

extension NFCReader where TagType == NDEFMessage {
    #if canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ session: TagType.ReaderSessionProtocol, _ messages: TagType.ReaderSessionDetectObject) -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFMessageReaderSessionCallbackHandleObject(
            taskPriority: taskPriority,
            didBecomeActive: didBecomeActive,
            didInvalidate: { error in
                didInvalidate(error)
                Task {
                    await self.invalidate()
                }
            },
            didDetectNDEFs: didDetectNDEFs
        )
        try await begin(
            sessionAndDelegate: { (.init(delegate: delegate, queue: taskPriority.map { .global(qos: $0.dispatchQoSClass) }, invalidateAfterFirstRead: invalidateAfterFirstRead), delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
