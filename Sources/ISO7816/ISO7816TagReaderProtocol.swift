//
//  ISO7816TagReaderProtocol.swift
//  ISO7816
//
//  Created by treastrain on 2022/11/22.
//

public protocol ISO7816TagReaderProtocol: NFCNativeTagReaderProtocol {}

extension ISO7816TagReaderProtocol {
    #if canImport(CoreNFC)
    public func connectAsISO7816Tag(to tag: NFCTag) async throws -> any NFCISO7816Tag {
        guard case .iso7816(let iso7816Tag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return iso7816Tag
    }
    #endif
}

#if canImport(CoreNFC)
extension NativeTag.Reader: ISO7816TagReaderProtocol {}
#endif
