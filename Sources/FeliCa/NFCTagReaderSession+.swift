//
//  NFCTagReaderSession+.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/20.
//

#if canImport(CoreNFC)
extension NFCTagReaderSession {
    public func connectAsFeliCaTag(to tag: NFCTag) async throws -> any NFCFeliCaTag {
        guard case .feliCa(let feliCaTag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return feliCaTag
    }
}
#endif
