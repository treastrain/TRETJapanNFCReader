//
//  NFCNativeTagReaderSessionAlertMessageable.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/23.
//

public protocol NFCNativeTagReaderSessionAlertMessageable: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: NFCNativeTagReaderSessionAlertMessageable {}
#endif
