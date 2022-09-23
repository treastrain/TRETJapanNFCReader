//
//  NFCNDEFTagReaderSessionAlertMessageable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCNDEFTagReaderSessionAlertMessageable: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFTagReaderSessionAlertMessageable {}
#endif
