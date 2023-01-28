//
//  NFCNativeTagReaderSessionCallbackHandleObject.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/19.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNativeTagReaderSessionCallbackHandleObject: NSObject, NFCReaderSessionCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NativeTag
    public let didBecomeActiveHandler: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    public let didInvalidateHandler: ((_ error: NFCReaderError) -> Void)
    public let didDetectHandler: ((_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        didBecomeActive: @escaping @Sendable (_: TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @escaping @Sendable (_: NFCReaderError) -> Void,
        didDetect: @escaping @Sendable (_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) {
        self.didBecomeActiveHandler = didBecomeActive
        self.didInvalidateHandler = didInvalidate
        self.didDetectHandler = didDetect
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNativeTagReaderSessionCallbackHandleObject: NativeTag.ReaderSession.Delegate {
    public nonisolated func tagReaderSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        didBecomeActive(session)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        didInvalidateWithError(session, error: error)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didDetect tags: TagType.ReaderSessionDetectObject) {
        Task {
            await didDetect(session: session, tags: tags)
        }
    }
}

extension NFCNativeTagReaderSessionCallbackHandleObject {
    func didDetect(session: NFCTagReaderSession, tags: [NFCTag]) async {
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
