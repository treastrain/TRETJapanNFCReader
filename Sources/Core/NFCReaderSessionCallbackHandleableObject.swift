//
//  NFCReaderSessionCallbackHandleableObject.swift
//  Core
//
//  Created by treastrain on 2022/09/25.
//

public protocol NFCReaderSessionCallbackHandleableObject: Actor {
    #if canImport(CoreNFC)
    associatedtype TagType: NFCTagType
    var didBecomeActiveHandler: (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void { get }
    var didInvalidateHandler: (_ error: NFCReaderError) -> Void { get }
    var didDetectHandler: (_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult { get }
    #endif
}

#if canImport(CoreNFC)
extension NFCReaderSessionCallbackHandleableObject {
    public nonisolated func didBecomeActive(_ session: TagType.ReaderSession.AfterBeginProtocol) {
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

extension NFCReaderSessionCallbackHandleableObject {
    private func didBecomeActive(session: TagType.ReaderSession.AfterBeginProtocol) {
        didBecomeActiveHandler(session)
    }
    
    private func didInvalidateWithError(session: TagType.ReaderSessionProtocol, error: Error) {
        didInvalidateHandler(error as! NFCReaderError)
    }
}
#endif

#if canImport(CoreNFC)
extension NFCReaderSessionCallbackHandleableObject where TagType.ReaderSession.Delegate == NFCNDEFReaderSessionDelegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        // TODO: remove `as!`
        didBecomeActive(session as! TagType.ReaderSession.AfterBeginProtocol)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        // TODO: remove `as!`
        didInvalidateWithError(session as! TagType.ReaderSessionProtocol, error: error)
    }
}

extension NFCReaderSessionCallbackHandleableObject where TagType.ReaderSession.Delegate == NFCTagReaderSessionDelegate {
    public nonisolated func tagReaderSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        // TODO: remove `as!`
        didBecomeActive(session as! TagType.ReaderSession.AfterBeginProtocol)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        // TODO: remove `as!`
        didInvalidateWithError(session as! TagType.ReaderSessionProtocol, error: error)
    }
}

extension NFCReaderSessionCallbackHandleableObject where TagType.ReaderSession.Delegate == NFCVASReaderSessionDelegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        // TODO: remove `as!`
        didBecomeActive(session as! TagType.ReaderSession.AfterBeginProtocol)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        // TODO: remove `as!`
        didInvalidateWithError(session as! TagType.ReaderSessionProtocol, error: error)
    }
}
#endif
