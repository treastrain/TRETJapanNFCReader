//
//  NFCNDEFMessageReaderSessionAlertMessageable.swift
//  Core
//
//  Created by treastrain on 2022/09/23.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCNDEFMessageReaderSessionAlertMessageable: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFMessageReaderSessionAlertMessageable {}
#endif
