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
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNativeTagReaderSessionCallbackHandleObject(
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
