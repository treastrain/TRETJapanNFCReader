//
//  NFCNDEFMessageReaderSessionCallbackHandleObject.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

public actor NFCNDEFMessageReaderSessionCallbackHandleObject: NSObject, NFCReaderSessionCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NDEFMessage
    public let taskPriority: TaskPriority?
    public let didBecomeActiveHandler: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    public let didInvalidateHandler: ((_ error: NFCReaderError) -> Void)
    public let didDetectHandler: ((_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        taskPriority: TaskPriority?,
        didBecomeActive: @escaping @Sendable (TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void,
        didDetectNDEFs: @escaping @Sendable (TagType.ReaderSessionProtocol, TagType.ReaderSessionDetectObject) -> TagType.DetectResult
    ) {
        self.taskPriority = taskPriority
        self.didBecomeActiveHandler = didBecomeActive
        self.didInvalidateHandler = didInvalidate
        self.didDetectHandler = didDetectNDEFs
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFMessageReaderSessionCallbackHandleObject: NDEFMessage.ReaderSession.Delegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        didBecomeActive(session as! TagType.ReaderSession.AfterBeginProtocol)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        didInvalidateWithError(session as! TagType.ReaderSessionProtocol, error: error)
    }
    
    public nonisolated func readerSession(_ session: TagType.ReaderSession, didDetectNDEFs messages: TagType.ReaderSessionDetectObject) {
        Task(priority: taskPriority) {
            await didDetectNDEFs(session: session, messages: messages)
        }
    }
}

extension NFCNDEFMessageReaderSessionCallbackHandleObject {
    func didDetectNDEFs(session: NFCNDEFReaderSession, messages: [NFCNDEFMessage]) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetectHandler(session as! TagType.ReaderSessionProtocol, messages)
        } catch {
            assertionFailure("Due to protocol restrictions, an error can be thrown in `NFCNDEFMessageReaderSessionCallbackHandleObject.didDetectHandler`, but it is treated as a success.")
            result = .success(alertMessage: nil)
        }
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
