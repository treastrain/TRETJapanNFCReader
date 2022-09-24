//
//  NFCNDEFMessageReaderSessionProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/23.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCNDEFMessageReaderSessionProtocol: NFCNDEFMessageReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFMessageReaderSessionProtocol {}
#endif
