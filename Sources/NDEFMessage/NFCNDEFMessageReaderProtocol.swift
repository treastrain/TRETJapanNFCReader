//
//  NFCNDEFMessageReaderProtocol.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public protocol NFCNDEFMessageReaderProtocol: NFCReaderAfterBeginProtocol {
    #if canImport(CoreNFC)
    #endif
}

#if canImport(CoreNFC)
extension NDEFMessage.Reader: NFCNDEFMessageReaderProtocol {}
#endif