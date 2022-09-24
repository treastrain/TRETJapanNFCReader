//
//  NFCNativeTagReaderSessionCallbackHandleObject.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/19.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNativeTagReaderSessionCallbackHandleObject: NSObject {
    #if canImport(CoreNFC)
    typealias TagType = NativeTag
    let didBecomeActive: ((_ session: TagType.ReaderSessionAlertMessageable) -> Void)
    let didInvalidate: ((_ error: NFCReaderError) -> Void)
    let didDetect: ((_ session: TagType.ReaderSessionProtocol, _ objects: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        didBecomeActive: @Sendable @escaping (_: TagType.ReaderSessionAlertMessageable) -> Void,
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
extension NFCNativeTagReaderSessionCallbackHandleObject: NFCTagReaderSessionDelegate {
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

extension NFCNativeTagReaderSessionCallbackHandleObject {
    func didBecomeActive(session: NFCTagReaderSession) {
        didBecomeActive(session)
    }
    
    func didInvalidateWithError(session: NFCTagReaderSession, error: Error) {
        didInvalidate(error as! NFCReaderError)
    }
    
    func didDetect(session: NFCTagReaderSession, tags: [NFCTag]) async {
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
