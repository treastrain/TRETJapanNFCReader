//
//  NFCNativeTagReaderSessionCallbackHandleObject.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/19.
//

#if canImport(CoreNFC)
@preconcurrency import CoreNFC
#endif

#if canImport(ObjectiveC)
public actor NFCNativeTagReaderSessionCallbackHandleObject: NSObject, NFCReaderSessionCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NativeTag
    public let taskPriority: TaskPriority?
    public let didBecomeActiveHandler: ((_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void)
    public let didInvalidateHandler: ((_ error: NFCReaderError) -> Void)
    public let didDetectHandler: ((_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult)
    
    init(
        taskPriority: TaskPriority?,
        didBecomeActive: @escaping @Sendable (_: TagType.ReaderSession.AfterBeginProtocol) -> Void,
        didInvalidate: @escaping @Sendable (_: NFCReaderError) -> Void,
        didDetect: @escaping @Sendable (_: TagType.ReaderSessionProtocol, _: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) {
        self.taskPriority = taskPriority
        self.didBecomeActiveHandler = didBecomeActive
        self.didInvalidateHandler = didInvalidate
        self.didDetectHandler = didDetect
    }
    #endif
}
#endif

#if canImport(ObjectiveC) && canImport(CoreNFC)
extension NFCNativeTagReaderSessionCallbackHandleObject: NativeTag.ReaderSession.Delegate {
    public nonisolated func tagReaderSessionDidBecomeActive(_ session: TagType.ReaderSession) {
        didBecomeActive(session as! TagType.ReaderSession.AfterBeginProtocol)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didInvalidateWithError error: Error) {
        didInvalidateWithError(session as! TagType.ReaderSessionProtocol, error: error)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.ReaderSession, didDetect tags: TagType.ReaderSessionDetectObject) {
        Task(priority: taskPriority) {
            await didDetect(session: session, tags: tags)
        }
    }
}

extension NFCNativeTagReaderSessionCallbackHandleObject {
    func didDetect(session: NFCTagReaderSession, tags: [NFCTag]) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetectHandler(session as! TagType.ReaderSessionProtocol, tags)
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
