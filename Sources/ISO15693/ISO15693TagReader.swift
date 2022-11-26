//
//  ISO15693TagReader.swift
//  ISO15693
//
//  Created by treastrain on 2022/11/26.
//

public typealias ISO15693TagReader = NFCReader<NativeTag>

extension ISO15693TagReader {
    public typealias ReaderSessionProtocol = any ISO15693TagReaderSessionProtocol
}

extension ISO15693TagReader {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso15693,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ISO15693TagReaderSessionProtocol, $1) }
        )
    }
    #endif
}