//
//  NFCNDEFMessageReaderSessionCallbackHandleObject.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFMessageReaderSessionCallbackHandleObject: NSObject {
    #if canImport(CoreNFC)
    typealias TagType = NDEFMessage
    let didBecomeActive: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    let didInvalidate: ((_ error: NFCReaderError) -> Void)
    let didDetectNDEFs: ((_ session: TagType.ReaderSessionProtocol, _ objects: TagType.ReaderSessionDetectObject) -> TagType.DetectResult)
    
    init(
        didBecomeActive: @Sendable @escaping (TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void,
        didDetectNDEFs: @Sendable @escaping (TagType.ReaderSessionProtocol, TagType.ReaderSessionDetectObject) -> TagType.DetectResult
    ) {
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetectNDEFs = didDetectNDEFs
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFMessageReaderSessionCallbackHandleObject: NFCNDEFReaderSessionDelegate {
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
        Task {
            await didDetectNDEFs(session: session, messages: messages)
        }
    }
}

extension NFCNDEFMessageReaderSessionCallbackHandleObject {
    func didBecomeActive(session: NFCNDEFReaderSession) {
        didBecomeActive(session)
    }
    
    func didInvalidateWithError(session: NFCNDEFReaderSession, error: Error) {
        didInvalidate(error as! NFCReaderError)
    }
    
    func didDetectNDEFs(session: NFCNDEFReaderSession, messages: [NFCNDEFMessage]) {
        let result = didDetectNDEFs(session, messages)
        switch result {
        case .success(let alertMessage):
            if let alertMessage {
                session.alertMessage = alertMessage
            }
            session.invalidate()
        case .restartPolling(let alertMessage):
            if let alertMessage {
                session.alertMessage = alertMessage
            }
            session.restartPolling()
        case .continue:
            break
        }
    }
}
#endif
