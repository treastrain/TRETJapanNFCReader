//
//  NFCNDEFTagReaderSessionAlertMessageable.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCNDEFTagReaderSessionAlertMessageable: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFTagReaderSessionAlertMessageable {}
#endif
