//
//  NFCReader+NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NDEFMessage {
    #if canImport(ObjectiveC) && canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @escaping @Sendable (_ reader: TagType.ReaderProtocol, _ messages: TagType.ReaderDetectObject) async -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFMessageReaderCallbackHandleObject(
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
        let reader = TagType.Reader(
            delegate: delegate,
            taskPriority: taskPriority,
            invalidateAfterFirstRead: invalidateAfterFirstRead
        )
        delegate.reader = reader
        try await begin(
            readerAndDelegate: { (reader, delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
