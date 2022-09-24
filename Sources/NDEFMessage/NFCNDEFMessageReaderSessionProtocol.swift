//
//  NFCNDEFMessageReaderSessionProtocol.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public protocol NFCNDEFMessageReaderSessionProtocol: NFCReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFMessageReaderSessionProtocol {}
#endif
