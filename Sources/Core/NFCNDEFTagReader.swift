//
//  NFCNDEFTagReader.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFTagReader: NSObject {
    #if canImport(CoreNFC)
    private var session: NFCNDEFReaderSession?
    private var didBecomeActive: ((_ session: any NFCNDEFTagReaderSessionAlertMessageable) -> Void)?
    private var didInvalidate: ((_ error: NFCReaderError) -> Void)?
    private var didDetect: ((_ session: any NFCNDEFTagReaderSessionProtocol, _ tags: [NFCNDEFTag]) async throws -> DetectTagResult)?
    
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: any NFCNDEFTagReaderSessionAlertMessageable) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: any NFCNDEFTagReaderSessionProtocol, _ tags: [NFCNDEFTag]) async throws -> DetectTagResult
    ) throws {
        guard NFCNDEFReaderSession.readingAvailable else {
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        // TODO: support the `queue`
        session = .init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
        session?.alertMessage = detectingAlertMessage
        session?.begin()
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFTagReader: NFCNDEFReaderSessionDelegate {
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

extension NFCNDEFTagReader {
    func didBecomeActive(session: NFCNDEFReaderSession) {
        didBecomeActive?(session)
    }
    
    func didInvalidateWithError(session: NFCNDEFReaderSession, error: Error) {
        didInvalidate?(error as! NFCReaderError)
    }
    
    func didDetect(session: NFCNDEFReaderSession, tags: [NFCNDEFTag]) async {
        guard let didDetect else { return }
        let result: DetectTagResult
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
