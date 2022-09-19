//
//  NFCTagReader.swift
//  Core
//
//  Created by treastrain on 2022/09/19.
//

import Foundation
#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCTagReader: NSObject {
    #if canImport(CoreNFC)
    private var session: NFCTagReaderSession?
    private var didBecomeActive: (() async -> Void)?
    private var didInvalidate: ((_ error: NFCReaderError) async -> Void)?
    private var didDetect: ((_ session: any NFCTagReaderSessionProtocol, _ tags: [NFCTag]) async throws -> DetectTagResult)?
    
    public func read(
        pollingOption: NFCTagReaderSession.PollingOption,
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping () async -> Void = {},
        didInvalidate: @Sendable @escaping (NFCReaderError) async -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: any NFCTagReaderSessionProtocol, _ tags: [NFCTag]) async throws -> DetectTagResult
    ) throws {
        guard NFCTagReaderSession.readingAvailable else {
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        // TODO: support the `queue`
        session = .init(pollingOption: pollingOption, delegate: self, queue: nil)
        guard session != nil else {
            if pollingOption.isEmpty {
                // FIXME: replace with more accurate error
                throw NFCReaderError(.readerErrorInvalidParameter)
            } else {
                // FIXME: set the `userInfo`
                throw NFCReaderError(.readerSessionInvalidationErrorSystemIsBusy)
            }
        }
        self.didBecomeActive = didBecomeActive
        self.didInvalidate = didInvalidate
        self.didDetect = didDetect
        session?.alertMessage = detectingAlertMessage
        session?.begin()
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReader: NFCTagReaderSessionDelegate {
    nonisolated public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        Task {
            await didBecomeActive(session: session)
        }
    }
    
    nonisolated public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        Task {
            await didInvalidateWithError(session: session, error: error)
        }
    }
    
    nonisolated public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        Task {
            await didDetect(session: session, tags: tags)
        }
    }
}

extension NFCTagReader {
    func didBecomeActive(session: NFCTagReaderSession) async {
        await didBecomeActive?()
    }
    
    func didInvalidateWithError(session: NFCTagReaderSession, error: Error) async {
        await didInvalidate?(error as! NFCReaderError)
    }
    
    func didDetect(session: NFCTagReaderSession, tags: [NFCTag]) async {
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
