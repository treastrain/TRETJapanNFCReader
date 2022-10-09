//
//  NFCReader+NativeTag.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NativeTag {
    #if canImport(CoreNFC)
    public func read(
        pollingOption: NFCTagReaderSession.PollingOption,
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) throws {
        let delegate = NFCNativeTagReaderSessionCallbackHandleObject(
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: didDetect
        )
        try read(
            sessionAndDelegate: {
                // TODO: support the `queue`
                guard let session = TagType.ReaderSession(pollingOption: pollingOption, delegate: delegate, queue: nil) else {
                    if pollingOption.isEmpty {
                        // FIXME: replace with more accurate error
                        throw NFCReaderError(.readerErrorInvalidParameter)
                    } else {
                        // FIXME: set the `userInfo`
                        throw NFCReaderError(.readerSessionInvalidationErrorSystemIsBusy)
                    }
                }
                return (session, delegate)
            },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
