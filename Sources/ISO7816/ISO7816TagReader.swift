//
//  ISO7816TagReader.swift
//  ISO7816
//
//  Created by treastrain on 2022/11/22.
//

public typealias ISO7816TagReader = NFCReader<NativeTag>

extension ISO7816TagReader {
    #if canImport(CoreNFC)
    public typealias ReaderProtocol = _OpaqueTypeBuilder.AfterDetectProtocol // it means like `some ISO7816TagReaderProtocol`
    #endif
}

#if canImport(CoreNFC)
extension ISO7816TagReader {
    public enum _OpaqueTypeBuilder: _NFCReaderOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderAfterBeginProtocol`, which will not be called from either place.
        public var afterBeginProtocol: some NFCReaderAfterBeginProtocol {
            afterDetectProtocol
        }
        /// This is a dummy property to give `AfterDetectProtocol` to `some ISO7816TagReaderProtocol`, which will not be called from either place.
        public var afterDetectProtocol: some ISO7816TagReaderProtocol {
            NativeTag.Reader(pollingOption: [], delegate: { fatalError("Do not call this property.") }(), taskPriority: nil)!
        }
    }
}
#endif

extension ISO7816TagReader {
    #if canImport(CoreNFC)
    public func read(
        taskPriority: TaskPriority? = nil,
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ reader: TagType.Reader.AfterBeginProtocol) async -> Void = { _ in },
        didInvalidate: @escaping @Sendable (_ error: NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ reader: ReaderProtocol, _ tags: TagType.ReaderDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso14443,
            taskPriority: taskPriority,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderProtocol, $1) }
        )
    }
    #endif
}
