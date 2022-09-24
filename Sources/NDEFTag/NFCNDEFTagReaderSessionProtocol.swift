//
//  NFCNDEFTagReaderSessionProtocol.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCNDEFTagReaderSessionProtocol: NFCReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    func connect(to tag: NFCNDEFTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFTagReaderSessionProtocol {}
#endif
