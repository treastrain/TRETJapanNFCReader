//
//  NFCTagType.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCTagType {
    #if canImport(CoreNFC)
    associatedtype Reader: NFCReaderProtocol
    associatedtype ReaderProtocol: NFCReaderAfterBeginProtocol
    associatedtype ReaderDetectObject
    #endif
    associatedtype DetectResult: NFCTagTypeDetectResult
}

public protocol NFCTagTypeDetectResult: Sendable {
    static var success: Self { get }
    static func success(alertMessage: String?) -> Self
    static var restartPolling: Self { get }
    static func restartPolling(alertMessage: String?) -> Self
}

public protocol NFCTagTypeFailableDetectResult: NFCTagTypeDetectResult {
    static func failure(errorMessage: String) -> Self
    static func failure(with error: any Error) -> Self
}

public protocol _NFCTagTypeOpaqueTypeBuilderProtocol {
    #if canImport(CoreNFC)
    associatedtype ReaderProtocol: NFCReaderAfterBeginProtocol
    var readerProtocol: ReaderProtocol { get }
    #endif
}
