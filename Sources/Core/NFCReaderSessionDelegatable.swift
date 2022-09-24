//
//  NFCReaderSessionDelegatable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

#if canImport(CoreNFC)
public protocol NFCReaderSessionDelegatable: NFCReaderSession {
    associatedtype CallbackHandleObject
}
#endif

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCReaderSessionDelegatable {
    public typealias CallbackHandleObject = NFCNDEFReaderSessionDelegate
}
#endif
