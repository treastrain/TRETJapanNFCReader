//
//  NFCReaderSessionable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
public protocol NFCReaderSessionable: NFCReaderSession {
    associatedtype Session
    associatedtype Delegate // TODO: inherit `NSObjectProtocol`
    associatedtype AfterBeginProtocol: Sendable
}
#endif

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCReaderSessionable, @unchecked Sendable {
    public typealias Session = NFCNDEFReaderSession
    public typealias Delegate = NFCNDEFReaderSessionDelegate
}

extension NFCTagReaderSession: NFCReaderSessionable, @unchecked Sendable {
    public typealias Session = NFCTagReaderSession
    public typealias Delegate = NFCTagReaderSessionDelegate
}

extension NFCVASReaderSession: NFCReaderSessionable, @unchecked Sendable {
    public typealias Session = NFCVASReaderSession
    public typealias Delegate = NFCVASReaderSessionDelegate
}
#endif

#if canImport(CoreNFC)
extension NFCReaderSessionable {
    public typealias AfterBeginProtocol = any NFCReaderSessionAfterBeginProtocol
}
#endif
