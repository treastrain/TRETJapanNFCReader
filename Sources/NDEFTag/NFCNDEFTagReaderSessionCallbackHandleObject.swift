//
//  NFCNDEFTagReaderSessionCallbackHandleObject.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFTagReaderSessionCallbackHandleObject: NSObject, NFCReaderSessionCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NDEFTag
    public let didBecomeActiveHandler: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    public let didInvalidateHandler: ((_ error: NFCReaderError) -> Void)
    public let didDetectHandler: ((_ session: TagType.ReaderSessionProtocol, _ objects: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        didBecomeActive: @Sendable @escaping (_: TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (_: NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_: TagType.ReaderSessionProtocol, _: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) {
        self.didBecomeActiveHandler = didBecomeActive
        self.didInvalidateHandler = didInvalidate
        self.didDetectHandler = didDetect
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFTagReaderSessionCallbackHandleObject: NDEFTag.ReaderSession.Delegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        didBecomeActive(session)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        didInvalidateWithError(session, error: error)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("If you want to use a reader via this method, use `NFCReader<NDEFMessage>`.")
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didDetect tags: TagType.ReaderSessionDetectObject) {
        Task {
            await didDetect(session: session, tags: tags)
        }
    }
}

extension NFCNDEFTagReaderSessionCallbackHandleObject {
    func didDetect(session: NFCNDEFReaderSession, tags: [NFCNDEFTag]) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetectHandler(session, tags)
        } catch {
            result = .failure(with: error)
        }
        switch result {
        case .success(let alertMessage):
            if let alertMessage {
                session.alertMessage = alertMessage
            }
            session.invalidate()
        case .failure(let errorMessage):
            session.invalidate(errorMessage: errorMessage)
        case .restartPolling(let alertMessage):
            if let alertMessage {
                session.alertMessage = alertMessage
            }
            session.restartPolling()
        case .none:
            break
        }
    }
}
#endif
