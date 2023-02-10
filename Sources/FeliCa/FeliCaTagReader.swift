//
//  FeliCaTagReader.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/21.
//

public typealias FeliCaTagReader = NFCReader<NativeTag>

extension FeliCaTagReader {
    #if canImport(CoreNFC)
    public typealias ReaderSessionProtocol = _FeliCaTagReaderOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some FeliCaTagReaderSessionProtocol`
    #endif
}

#if canImport(CoreNFC)
public enum _FeliCaTagReaderOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    public var readerSessionProtocol: some FeliCaTagReaderSessionProtocol {
        NativeTag.ReaderSession(pollingOption: [], delegate: _NFCTagReaderSessionOpaqueTypeBuilder())!
    }
}
#endif

extension FeliCaTagReader {
    #if canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso18092,
            taskPriority: taskPriority,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderSessionProtocol, $1) }
        )
    }
    #endif
}
