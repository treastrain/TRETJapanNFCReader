//
//  NFCNDEFMessageReaderCallbackHandleObject.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

#if canImport(CoreNFC)
@preconcurrency import class CoreNFC.NFCNDEFMessage
#endif

#if canImport(ObjectiveC)
public actor NFCNDEFMessageReaderCallbackHandleObject: NSObject, NFCReaderCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NDEFMessage
    public let taskPriority: TaskPriority?
    public let didBecomeActiveHandler: (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void
    public let didInvalidateHandler: (_ error: NFCReaderError) -> Void
    public let didDetectHandler: (_ reader: TagType.ReaderProtocol, _ object: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    
    nonisolated lazy var reader: TagType.Reader = { preconditionFailure("Set that reader before beginning.") }()
    
    init(
        taskPriority: TaskPriority?,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void,
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void,
        didDetectNDEFs: @escaping @Sendable (_ reader: TagType.ReaderProtocol, _ object: TagType.ReaderDetectObject) async -> TagType.DetectResult
    ) {
        self.taskPriority = taskPriority
        self.didBecomeActiveHandler = didBecomeActive
        self.didInvalidateHandler = didInvalidate
        self.didDetectHandler = didDetectNDEFs
    }
    #endif
}
#endif

#if canImport(ObjectiveC) && canImport(CoreNFC)
extension NFCNDEFMessageReaderCallbackHandleObject: NDEFMessage.Reader.Delegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.Reader.Session) {
        Task(priority: taskPriority) {
            await didBecomeActive()
        }
    }
    
    public nonisolated func readerSession(_ session: TagType.Reader.Session, didInvalidateWithError error: any Error) {
        didInvalidateWithError(session, error: error)
    }
    
    public nonisolated func readerSession(_ session: TagType.Reader.Session, didDetectNDEFs messages: TagType.ReaderDetectObject) {
        Task(priority: taskPriority) {
            await didDetectNDEFs(messages: messages)
        }
    }
}

extension NFCNDEFMessageReaderCallbackHandleObject {
    func didBecomeActive() async {
        await didBecomeActiveHandler(reader as! TagType.Reader.AfterBeginProtocol)
    }
    
    func didDetectNDEFs(messages: TagType.ReaderDetectObject) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetectHandler(reader as! TagType.ReaderProtocol, messages)
        } catch {
            assertionFailure("Due to protocol restrictions, an error can be thrown in `NFCNDEFMessageReaderCallbackHandleObject.didDetectHandler`, but it is treated as a success.")
            result = .success(alertMessage: nil)
        }
        switch result {
        case .success(let alertMessage):
            if let alertMessage {
                await reader.set(alertMessage: alertMessage)
            }
            await reader.invalidate()
        case .restartPolling(let alertMessage):
            if let alertMessage {
                await reader.set(alertMessage: alertMessage)
            }
            await reader.restartPolling()
        case .continue:
            break
        }
    }
}
#endif
