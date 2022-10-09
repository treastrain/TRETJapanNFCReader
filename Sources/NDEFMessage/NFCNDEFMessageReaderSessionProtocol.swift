//
//  NFCNDEFMessageReaderSessionProtocol.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public protocol NFCNDEFMessageReaderSessionProtocol: NFCReaderSessionAfterBeginProtocol {
    #if canImport(CoreNFC)
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFMessageReaderSessionProtocol {}
#endif
