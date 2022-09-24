//
//  NFCReaderSessionCallbackHandleObject.swift
//  Core
//
//  Created by treastrain on 2022/09/25.
//

public protocol NFCReaderSessionCallbackHandleObject: Actor {
    #if canImport(CoreNFC)
    associatedtype TagType: NFCTagType
    var didBecomeActiveHandler: (_ session: TagType.ReaderSession.AlertMessageable) -> Void { get }
    var didInvalidateHandler: (_ error: NFCReaderError) -> Void { get }
    var didDetectHandler: (_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult { get }
    #endif
}

#if canImport(CoreNFC)
extension NFCReaderSessionCallbackHandleObject {
    public nonisolated func didBecomeActive(_ session: TagType.ReaderSession.AlertMessageable) {
        Task {
            await didBecomeActive(session: session)
        }
    }
    
    public nonisolated func didInvalidateWithError(_ session: TagType.ReaderSessionProtocol, error: Error) {
        Task {
            await didInvalidateWithError(session: session, error: error)
        }
    }
}

extension NFCReaderSessionCallbackHandleObject {
    private func didBecomeActive(session: TagType.ReaderSession.AlertMessageable) {
        didBecomeActiveHandler(session)
    }
    
    private func didInvalidateWithError(session: TagType.ReaderSessionProtocol, error: Error) {
        didInvalidateHandler(error as! NFCReaderError)
    }
}
#endif

#if canImport(CoreNFC)
extension NFCReaderSessionCallbackHandleObject where TagType.ReaderSession.CallbackHandleObject == NFCTagReaderSessionDelegate {
    public nonisolated func tagReaderSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        didBecomeActive(session as! TagType.ReaderSession.AlertMessageable)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        didInvalidateWithError(session as! Self.TagType.ReaderSessionProtocol, error: error)
    }
}
#endif
