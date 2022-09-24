//
//  NFCReaderSessionDelegatable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
public protocol NFCReaderSessionDelegatable: NFCReaderSession {
    associatedtype CallbackHandleObject
    associatedtype AlertMessageable: Sendable
}
#endif

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCReaderSessionDelegatable {
    public typealias CallbackHandleObject = NFCNDEFReaderSessionDelegate
}

extension NFCTagReaderSession: NFCReaderSessionDelegatable {
    public typealias CallbackHandleObject = NFCTagReaderSessionDelegate
}

extension NFCVASReaderSession: NFCReaderSessionDelegatable {
    public typealias CallbackHandleObject = NFCVASReaderSessionDelegate
}
#endif

#if canImport(CoreNFC)
extension NFCReaderSessionDelegatable {
    public typealias AlertMessageable = NFCReaderSessionAlertMessageable
}
#endif
