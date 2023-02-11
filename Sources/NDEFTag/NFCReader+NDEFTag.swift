//
//  NFCReader+NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

@_spi(TaskPriorityToDispatchQoSClass) import TRETNFCKit_Core

extension NFCReader where TagType == NDEFTag {
    #if canImport(ObjectiveC) && canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFTagReaderSessionCallbackHandleObject(
            taskPriority: taskPriority,
            didBecomeActive: didBecomeActive,
            didInvalidate: { error in
                didInvalidate(error)
                Task {
                    await self.invalidate()
                }
            },
            didDetect: didDetect
        )
        try await begin(
            sessionAndDelegate: { (.init(delegate: delegate, queue: taskPriority.map { .global(qos: $0.dispatchQoSClass) }, invalidateAfterFirstRead: false), delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
