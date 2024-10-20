//
//  NFCTagReaderSession+.swift
//  ISO15693
//
//  Created by treastrain on 2022/11/26.
//

#if canImport(CoreNFC)
extension NFCTagReaderSession {
    public func connectAsISO15693Tag(to tag: NFCTag) async throws -> any NFCISO15693Tag {
        guard case .iso15693(let iso15693Tag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return iso15693Tag
    }
}
#endif
