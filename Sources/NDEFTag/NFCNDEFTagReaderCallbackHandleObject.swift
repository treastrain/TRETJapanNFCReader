//
//  NFCNDEFTagReaderCallbackHandleObject.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
@preconcurrency import protocol CoreNFC.NFCNDEFTag
#endif

#if canImport(ObjectiveC)
public actor NFCNDEFTagReaderCallbackHandleObject: NSObject, NFCReaderCallbackHandleableObject {
    #if canImport(CoreNFC)
    public typealias TagType = NDEFTag
    public let taskPriority: TaskPriority?
    public let didBecomeActiveHandler: (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void
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
extension NFCNDEFTagReaderCallbackHandleObject: NDEFTag.Reader.Delegate {
    public nonisolated func readerSessionDidBecomeActive(_ session: TagType.Reader.Session) {
        Task(priority: taskPriority) {
            await didBecomeActive()
        }
    }
    
    public nonisolated func readerSession(_ session: TagType.Reader.Session, didInvalidateWithError error: Error) {
        didInvalidateWithError(session, error: error)
    }
    
    public nonisolated func readerSession(_ session: TagType.Reader.Session, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("If you want to use a reader via this method, use `NFCReader<NDEFMessage>`.")
    }
    
    public nonisolated func readerSession(_ session: TagType.Reader.Session, didDetect tags: TagType.ReaderDetectObject) {
        Task(priority: taskPriority) {
            await didDetect(tags: tags)
        }
    }
}

extension NFCNDEFTagReaderCallbackHandleObject {
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
