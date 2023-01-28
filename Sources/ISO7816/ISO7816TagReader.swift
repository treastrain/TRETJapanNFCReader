//
//  ISO7816TagReader.swift
//  ISO7816
//
//  Created by treastrain on 2022/11/22.
//

public typealias ISO7816TagReader = NFCReader<NativeTag>

extension ISO7816TagReader {
    public typealias ReaderSessionProtocol = any ISO7816TagReaderSessionProtocol
}

extension ISO7816TagReader {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @escaping @Sendable (_ session: TagType.ReaderSession.AfterBeginProtocol) -> Void = { _ in },
        didInvalidate: @escaping @Sendable (NFCReaderError) -> Void = { _ in },
        didDetect: @escaping @Sendable (_ session: ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) async throws {
        try await read(
            pollingOption: .iso14443,
            detectingAlertMessage: detectingAlertMessage,
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: { try await didDetect($0 as! ReaderSessionProtocol, $1) }
        )
    }
    #endif
}
