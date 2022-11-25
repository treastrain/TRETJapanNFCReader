//
//  MiFareTagReader.swift
//  MiFare
//
//  Created by treastrain on 2022/11/26.
//

public typealias MiFareTagReader = NFCReader<NativeTag>

extension MiFareTagReader {
    public typealias ReaderSessionProtocol = any MiFareTagReaderSessionProtocol
}

extension MiFareTagReader {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso14443,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! MiFareTagReaderSessionProtocol, $1) }
        )
    }
    #endif
}
