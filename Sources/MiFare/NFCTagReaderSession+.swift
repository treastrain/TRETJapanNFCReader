//
//  NFCTagReaderSession+.swift
//  MiFare
//
//  Created by treastrain on 2022/11/26.
//

#if canImport(CoreNFC)
extension NFCTagReaderSession {
    public func connectAsMiFareTag(to tag: NFCTag) async throws -> any NFCMiFareTag {
        guard case .miFare(let miFareTag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return miFareTag
    }
}
#endif
