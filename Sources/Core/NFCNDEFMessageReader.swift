//
//  NFCNDEFMessageReader.swift
//  Core
//
//  Created by treastrain on 2022/09/23.
//

import Foundation
#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFMessageReader: NSObject {
    #if canImport(CoreNFC)
    private var session: NFCNDEFReaderSession?
    private var didBecomeActive: ((_ session: any NFCNDEFMessageReaderSessionAlertMessageable) -> Void)?
    private var didInvalidate: ((_ error: NFCReaderError) -> Void)?
    private var didDetectNDEFs: ((_ session: any NFCNDEFMessageReaderSessionProtocol, _ messages: [NFCNDEFMessage]) -> DetectMessageResult)?
    
    public func read(
        invalidateAfterFirstRead: Bool,
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: any NFCNDEFMessageReaderSessionAlertMessageable) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetectNDEFs: @Sendable @escaping (_ session: any NFCNDEFMessageReaderSessionProtocol, _ messages: [NFCNDEFMessage]) -> DetectMessageResult
    ) throws {
        guard NFCNDEFReaderSession.readingAvailable else {
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        // TODO: support the `queue`
        session = .init(delegate: self, queue: nil, invalidateAfterFirstRead: invalidateAfterFirstRead)
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetectNDEFs = didDetectNDEFs
        session?.alertMessage = detectingAlertMessage
        session?.begin()
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFMessageReader: NFCNDEFReaderSessionDelegate {
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

extension NFCNDEFMessageReader {
    func didBecomeActive(session: NFCNDEFReaderSession) {
        didBecomeActive?(session)
    }
    
    func didInvalidateWithError(session: NFCNDEFReaderSession, error: Error) {
        didInvalidate?(error as! NFCReaderError)
    }
    
    func didDetectNDEFs(session: NFCNDEFReaderSession, messages: [NFCNDEFMessage]) {
        guard let didDetectNDEFs else { return }
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
