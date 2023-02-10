//
//  MiFareTagReader.swift
//  MiFare
//
//  Created by treastrain on 2022/11/26.
//

public typealias MiFareTagReader = NFCReader<NativeTag>

extension MiFareTagReader {
    #if canImport(CoreNFC)
    public typealias ReaderSessionProtocol = _MiFareTagReaderOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some MiFareTagReaderSessionProtocol`
    #endif
}

#if canImport(CoreNFC)
public enum _MiFareTagReaderOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    public var readerSessionProtocol: some MiFareTagReaderSessionProtocol {
        NativeTag.ReaderSession(pollingOption: [], delegate: _NFCTagReaderSessionOpaqueTypeBuilder())!
    }
}
#endif

extension MiFareTagReader {
    #if canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso14443,
            taskPriority: taskPriority,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderSessionProtocol, $1) }
        )
    }
    #endif
}
