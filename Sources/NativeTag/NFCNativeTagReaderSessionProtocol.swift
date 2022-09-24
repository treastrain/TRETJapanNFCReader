//
//  NFCNativeTagReaderSessionProtocol.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/20.
//

public protocol NFCNativeTagReaderSessionProtocol: NFCNativeTagReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    func connect(to tag: NFCTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: NFCNativeTagReaderSessionProtocol {}
#endif