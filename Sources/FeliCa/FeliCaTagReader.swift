//
//  FeliCaTagReader.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/21.
//

public typealias FeliCaTagReader = NFCReader<NativeTag>

extension FeliCaTagReader {
    public typealias ReaderSessionProtocol = any FeliCaTagReaderSessionProtocol
}

extension FeliCaTagReader {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso18092,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderSessionProtocol, $1) }
        )
    }
    #endif
}
