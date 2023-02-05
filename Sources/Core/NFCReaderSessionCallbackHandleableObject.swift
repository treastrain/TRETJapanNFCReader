//
//  NFCReaderSessionCallbackHandleableObject.swift
//  Core
//
//  Created by treastrain on 2022/09/25.
//

public protocol NFCReaderSessionCallbackHandleableObject: Actor {
    #if canImport(CoreNFC)
    associatedtype TagType: NFCTagType
    nonisolated var taskPriority: TaskPriority? { get }
    var didBecomeActiveHandler: (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void { get }
    var didInvalidateHandler: (_ error: NFCReaderError) -> Void { get }
    var didDetectHandler: (_ session: TagType.ReaderSessionProtocol, _ object: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult { get }
    #endif
}

#if canImport(CoreNFC)
extension NFCReaderSessionCallbackHandleableObject {
    public nonisolated func didBecomeActive(_ session: TagType.ReaderSession.AfterBeginProtocol) {
        Task(priority: taskPriority) {
            await didBecomeActive(session: session)
        }
    }
    
    public nonisolated func didInvalidateWithError(_ session: TagType.ReaderSessionProtocol, error: Error) {
        Task(priority: taskPriority) {
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
