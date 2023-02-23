//
//  NFCNDEFTagReaderSessionProtocol.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCNDEFTagReaderSessionProtocol: NFCReaderSessionAfterBeginProtocol {
    #if canImport(CoreNFC)
    func connect(to tag: any NFCNDEFTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFTagReaderSessionProtocol {}
#endif
