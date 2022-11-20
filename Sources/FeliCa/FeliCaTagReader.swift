//
//  FeliCaTagReader.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/21.
//

public typealias FeliCaTagReader = NFCReader<NativeTag>

extension FeliCaTagReader {
    public typealias ReaderSessionProtocol = FeliCaTagReaderSessionProtocol
}

extension FeliCaTagReader {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso18092,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! FeliCaTagReaderSessionProtocol, $1) }
        )
    }
    #endif
}
