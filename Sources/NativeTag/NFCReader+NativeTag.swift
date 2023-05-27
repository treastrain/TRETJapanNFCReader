//
//  NFCReader+NativeTag.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NativeTag {
    #if canImport(ObjectiveC) && canImport(CoreNFC)
    public func read(
        pollingOption: NFCTagReaderSession.PollingOption,
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: TagType.ReaderProtocol, _ tags: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNativeTagReaderCallBackHandleObject(
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
        try await begin(
            readerAndDelegate: {
                guard let reader = TagType.Reader(pollingOption: pollingOption, delegate: delegate, taskPriority: taskPriority) else {
                    if pollingOption.isEmpty {
                        // FIXME: replace with more accurate error
                        throw NFCReaderError(.readerErrorInvalidParameter)
                    } else {
                        // FIXME: set the `userInfo`
                        throw NFCReaderError(.readerSessionInvalidationErrorSystemIsBusy)
                    }
                }
                delegate.reader = reader
                return (reader, delegate)
            },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
