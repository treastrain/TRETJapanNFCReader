//
//  NFCNDEFTagReaderSessionProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCNDEFTagReaderSessionProtocol: NFCNDEFTagReaderSessionAlertMessageable {
    #if canImport(CoreNFC)
    func connect(to tag: NFCNDEFTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCNDEFTagReaderSessionProtocol {}
#endif
