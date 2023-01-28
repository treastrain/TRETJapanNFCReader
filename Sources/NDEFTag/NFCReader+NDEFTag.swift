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
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
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
