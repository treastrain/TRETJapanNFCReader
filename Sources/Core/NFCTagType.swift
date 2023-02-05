//
//  NFCTagType.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCTagType {
    #if canImport(CoreNFC)
    associatedtype ReaderSession: NFCReaderSessionable
    associatedtype ReaderSessionProtocol: Sendable
    associatedtype ReaderSessionDetectObject
    #endif
    associatedtype DetectResult
}

public protocol _NFCTagTypeOpaqueTypeBuilderProtocol {
    #if canImport(CoreNFC)
    associatedtype ReaderSessionProtocol: Sendable
    var readerSessionProtocol: ReaderSessionProtocol { get }
    #endif
}
