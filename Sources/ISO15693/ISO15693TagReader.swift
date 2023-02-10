//
//  ISO15693TagReader.swift
//  ISO15693
//
//  Created by treastrain on 2022/11/26.
//

public typealias ISO15693TagReader = NFCReader<NativeTag>

extension ISO15693TagReader {
    #if canImport(CoreNFC)
    public typealias ReaderSessionProtocol = _ISO15693TagReaderOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some ISO15693TagReaderSessionProtocol`
    #endif
}

#if canImport(CoreNFC)
public enum _ISO15693TagReaderOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    public var readerSessionProtocol: some ISO15693TagReaderSessionProtocol {
        NativeTag.ReaderSession(pollingOption: [], delegate: _NFCTagReaderSessionOpaqueTypeBuilder())!
    }
}
#endif

extension ISO15693TagReader {
    #if canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso15693,
            taskPriority: taskPriority,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderSessionProtocol, $1) }
        )
    }
    #endif
}
