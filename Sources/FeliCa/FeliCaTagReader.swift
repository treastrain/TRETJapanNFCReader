//
//  FeliCaTagReader.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/21.
//

public typealias FeliCaTagReader = NFCReader<NativeTag>

extension FeliCaTagReader: NativeTagReaderProtocol {
    #if canImport(CoreNFC)
    public typealias ReaderProtocol = _OpaqueTypeBuilder.ReaderProtocol // it means like `some FeliCaTagReaderProtocol`
    
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: ReaderProtocol, _ tags: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso18092,
            taskPriority: taskPriority,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderProtocol, $1) }
        )
    }
    #endif
}

#if canImport(CoreNFC)
extension FeliCaTagReader {
    public enum _OpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
        public var readerProtocol: some FeliCaTagReaderProtocol {
            NativeTag.Reader(pollingOption: [], delegate: { fatalError("Do not call this property.") }(), taskPriority: nil)!
        }
    }
}
#endif
