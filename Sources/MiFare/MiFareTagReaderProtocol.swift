//
//  MiFareTagReaderProtocol.swift
//  MiFare
//
//  Created by treastrain on 2022/11/26.
//

public protocol MiFareTagReaderProtocol: NFCNativeTagReaderProtocol {}

extension MiFareTagReaderProtocol {
    #if canImport(CoreNFC)
    public func connectAsMiFareTag(to tag: NFCTag) async throws -> any NFCMiFareTag {
        guard case .miFare(let miFareTag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return miFareTag
    }
    #endif
}

#if canImport(CoreNFC)
extension NativeTag.Reader: MiFareTagReaderProtocol {}
#endif
