//
//  MiFareTagReaderSessionProtocol.swift
//  MiFare
//
//  Created by treastrain on 2022/11/26.
//

public protocol MiFareTagReaderSessionProtocol: NFCNativeTagReaderSessionProtocol {}

extension MiFareTagReaderSessionProtocol {
    #if canImport(CoreNFC)
    public func connectAsMiFareTag(to tag: NFCTag) async throws -> NFCMiFareTag {
        guard case .miFare(let miFareTag) = tag else {
            throw NFCReaderError(.readerErrorInvalidParameter)
        }
        try await connect(to: tag)
        return miFareTag
    }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: MiFareTagReaderSessionProtocol {}
#endif
