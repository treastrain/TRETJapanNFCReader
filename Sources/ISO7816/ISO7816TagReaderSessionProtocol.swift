//
//  ISO7816TagReaderSessionProtocol.swift
//  ISO7816
//
//  Created by treastrain on 2022/11/22.
//

public protocol ISO7816TagReaderSessionProtocol: NFCNativeTagReaderSessionProtocol {}

extension ISO7816TagReaderSessionProtocol {
    #if canImport(CoreNFC)
    public func connectAsISO7816Tag(to tag: NFCTag) async throws -> NFCISO7816Tag {
        guard case .iso7816(let iso7816Tag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return iso7816Tag
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: ISO7816TagReaderSessionProtocol {}
#endif
