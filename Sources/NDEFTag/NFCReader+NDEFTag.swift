//
//  NFCReader+NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NDEFTag {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFTagReaderSessionCallbackHandleObject(
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
            // TODO: support the `queue`
            sessionAndDelegate: { (.init(delegate: delegate, queue: nil, invalidateAfterFirstRead: false), delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
