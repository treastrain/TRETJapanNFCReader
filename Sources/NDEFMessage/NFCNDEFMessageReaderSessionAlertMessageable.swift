//
//  NFCNDEFMessageReaderSessionAlertMessageable.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public protocol NFCNDEFMessageReaderSessionAlertMessageable: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFMessageReaderSessionAlertMessageable {}
#endif
