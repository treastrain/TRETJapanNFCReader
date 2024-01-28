//
//  NFCReaderCallbackHandleableObject.swift
//  Core
//
//  Created by treastrain on 2022/09/25.
//

public protocol NFCReaderCallbackHandleableObject: Actor {
    #if canImport(CoreNFC)
    associatedtype TagType: NFCTagType
    nonisolated var taskPriority: TaskPriority? { get }
    var didBecomeActiveHandler: (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void { get }
    var didInvalidateHandler: (_ error: NFCReaderError) -> Void { get }
    var didDetectHandler: (_ reader: TagType.ReaderProtocol, _ object: TagType.ReaderDetectObject) async throws -> TagType.DetectResult { get }
    #endif
}

#if canImport(CoreNFC)
extension NFCReaderCallbackHandleableObject {
    public nonisolated func didInvalidateWithError(_ session: TagType.Reader.Session, error: any Error) {
        Task(priority: taskPriority) {
            await didInvalidateWithError(error: error)
        }
    }
}

extension NFCReaderCallbackHandleableObject {
    private func didInvalidateWithError(error: any Error) {
        didInvalidateHandler(error as! NFCReaderError)
    }
}
#endif
