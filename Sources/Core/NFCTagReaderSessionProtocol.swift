//
//  NFCTagReaderSessionProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/20.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCTagReaderSessionProtocol: NFCTagReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    func connect(to tag: NFCTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: NFCTagReaderSessionProtocol {}
#endif
