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

public protocol NFCTagReaderSessionProtocol: NSObjectProtocol {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    func connect(to tag: NFCTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NFCTagReaderSession: NFCTagReaderSessionProtocol {}
#endif
