//
//  ISO15693TagReaderSessionProtocol.swift
//  ISO15693
//
//  Created by treastrain on 2022/11/26.
//

public protocol ISO15693TagReaderSessionProtocol: NFCNativeTagReaderSessionProtocol {}

extension ISO15693TagReaderSessionProtocol {
    #if canImport(CoreNFC)
    public func connectAsISO15693Tag(to tag: NFCTag) async throws -> NFCISO15693Tag {
        guard case .iso15693(let iso15693Tag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return iso15693Tag
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: ISO15693TagReaderSessionProtocol {}
#endif
