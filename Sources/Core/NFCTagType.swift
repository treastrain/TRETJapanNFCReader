//
//  NFCTagType.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public protocol NFCTagType {
    #if canImport(CoreNFC)
    associatedtype ReaderSession: NFCReaderSessionDelegatable
    associatedtype ReaderSessionAlertMessageable
    associatedtype ReaderSessionProtocol
    associatedtype ReaderSessionDetectObject
    #endif
    associatedtype DetectResult
}
