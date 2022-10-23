//
//  NFCReader+NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/24.
//

extension NFCReader where TagType == NDEFMessage {
    #if canImport(CoreNFC)
    public func read(
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @Sendable @escaping (_ session: TagType.ReaderSessionProtocol, _ messages: TagType.ReaderSessionDetectObject) -> TagType.DetectResult
    ) async throws {
        let delegate = NFCNDEFMessageReaderSessionCallbackHandleObject(
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
            // TODO: support the `queue`
            sessionAndDelegate: { (.init(delegate: delegate, queue: nil, invalidateAfterFirstRead: invalidateAfterFirstRead), delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
