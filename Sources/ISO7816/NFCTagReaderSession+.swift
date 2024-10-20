//
//  NFCTagReaderSession+.swift
//  ISO7816
//
//  Created by treastrain on 2022/11/22.
//

#if canImport(CoreNFC)
extension NFCTagReaderSession {
    public func connectAsISO7816Tag(to tag: NFCTag) async throws -> any NFCISO7816Tag {
        guard case .iso7816(let iso7816Tag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return iso7816Tag
    }
}
#endif
