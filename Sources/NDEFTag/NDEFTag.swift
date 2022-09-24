//
//  NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias ReaderSession = NFCNDEFReaderSession
    public typealias ReaderSessionAlertMessageable = NFCNDEFTagReaderSessionAlertMessageable
    public typealias ReaderSessionProtocol = NFCNDEFTagReaderSessionProtocol
    public typealias ReaderSessionDetectObject = [NFCNDEFTag]
    #endif
}

extension NDEFTag {
    public enum DetectResult: Sendable {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
    }
}

extension NDEFTag.DetectResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}