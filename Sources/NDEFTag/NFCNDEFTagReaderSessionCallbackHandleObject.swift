//
//  NFCNDEFTagReaderSessionCallbackHandleObject.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFTagReaderSessionCallbackHandleObject: NSObject {
    #if canImport(CoreNFC)
    typealias TagType = NDEFTag
    let didBecomeActive: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    let didInvalidate: ((_ error: NFCReaderError) -> Void)
    let didDetect: ((_ session: TagType.ReaderSessionProtocol, _ objects: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        didBecomeActive: @Sendable @escaping (_: TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (_: NFCReaderError) -> Void,
        didDetect: @Sendable @escaping (_: TagType.ReaderSessionProtocol, _: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) {
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFTagReaderSessionCallbackHandleObject: NFCNDEFReaderSessionDelegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        Task {
            await didBecomeActive(session: session)
        }
    }
    
    public nonisolated func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        Task {
            await didInvalidateWithError(session: session, error: error)
        }
    }
    
    public nonisolated func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("If you want to use a reader via this method, use `NFCNDEFMessageReader`.")
    }
    
    public nonisolated func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        Task {
            await didDetect(session: session, tags: tags)
        }
    }
}

extension NFCNDEFTagReaderSessionCallbackHandleObject {
    func didBecomeActive(session: NFCNDEFReaderSession) {
        didBecomeActive(session)
    }
    
    func didInvalidateWithError(session: NFCNDEFReaderSession, error: Error) {
        didInvalidate(error as! NFCReaderError)
    }
    
    func didDetect(session: NFCNDEFReaderSession, tags: [NFCNDEFTag]) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetect(session, tags)
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
