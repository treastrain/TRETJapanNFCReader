//
//  NFCReader+NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NDEFTag {
    #if canImport(ObjectiveC) && canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: TagType.ReaderProtocol, _ tags: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFTagReaderCallbackHandleObject(
            taskPriority: taskPriority,
            didBecomeActive: didBecomeActive,
            didInvalidate: { error in
                didInvalidate(error)
                Task {
                    await self._invalidateWithResetReaderAndDelegate()
                }
            },
            didDetect: didDetect
        )
        let reader = TagType.Reader(
            delegate: delegate,
            taskPriority: taskPriority,
            invalidateAfterFirstRead: false
        )
        delegate.reader = reader
        try await begin(
            readerAndDelegate: { (reader, delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
