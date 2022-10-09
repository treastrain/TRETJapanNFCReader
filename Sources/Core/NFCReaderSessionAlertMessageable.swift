//
//  NFCReaderSessionAlertMessageable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCReaderSessionAlertMessageable: NSObjectProtocol, Sendable {
    #if canImport(CoreNFC)
    var alertMessage: String { get set }
    #endif
}
