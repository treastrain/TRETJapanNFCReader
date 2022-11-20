//
//  FeliCaTagReaderSessionProtocol.swift
//  FeliCa
//
//  Created by treastrain on 2022/11/20.
//

public protocol FeliCaTagReaderSessionProtocol: NFCNativeTagReaderSessionProtocol {}

extension FeliCaTagReaderSessionProtocol {
    #if canImport(CoreNFC)
    public func connectAsFeliCaTag(to tag: NFCTag) async throws -> any NFCFeliCaTag {
        guard case .feliCa(let feliCaTag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return feliCaTag
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: FeliCaTagReaderSessionProtocol {}
#endif
