//
//  NFCNativeTagReaderCallBackHandleObject.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/19.
//

#if canImport(CoreNFC)
public import enum CoreNFC.NFCTag
#endif

#if canImport(ObjectiveC)
public actor NFCNativeTagReaderCallBackHandleObject: NSObject, NFCReaderCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NativeTag
    public let taskPriority: TaskPriority?
    public let didBecomeActiveHandler: (_ reader:TagType.Reader.AfterBeginProtocol) async -> Void
    public let didInvalidateHandler: (_ error: NFCReaderError) -> Void
    public let didDetectHandler: (_ reader: TagType.ReaderProtocol, _ object: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    
    nonisolated lazy var reader: TagType.Reader = { preconditionFailure("Set that reader before beginning.") }()
    
    init(
        taskPriority: TaskPriority?,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void,
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void,
        didDetect: @escaping @Sendable (_ reader: TagType.ReaderProtocol, _ object: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
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
extension NFCNativeTagReaderCallBackHandleObject: NativeTag.Reader.Delegate {
    public nonisolated func tagReaderSessionDidBecomeActive(_ session: TagType.Reader.Session) {
        Task(priority: taskPriority) {
            await didBecomeActive()
        }
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.Reader.Session, didInvalidateWithError error: any Error) {
        didInvalidateWithError(session, error: error)
    }
    
    public nonisolated func tagReaderSession(_ session: TagType.Reader.Session, didDetect tags: TagType.ReaderDetectObject) {
        Task(priority: taskPriority) {
            await didDetect(tags: tags)
        }
    }
}

extension NFCNativeTagReaderCallBackHandleObject {
    func didBecomeActive() async {
        await didBecomeActiveHandler(reader as! TagType.Reader.AfterBeginProtocol)
    }
    
    func didDetect(tags: TagType.ReaderDetectObject) async {
        let result: TagType.DetectResult
        do {
            result = try await didDetectHandler(reader as! TagType.ReaderProtocol, tags)
        } catch {
            result = .failure(with: error)
        }
        switch result {
        case .success(let alertMessage):
            if let alertMessage {
                await reader.set(alertMessage: alertMessage)
            }
            await reader.invalidate()
        case .failure(let errorMessage):
            await reader.invalidate(errorMessage: errorMessage)
        case .restartPolling(let alertMessage):
            if let alertMessage {
                await reader.set(alertMessage: alertMessage)
            }
            await reader.restartPolling()
        case .none:
            break
        }
    }
}
#endif
