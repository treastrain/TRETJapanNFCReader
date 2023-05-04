//
//  NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFMessage: NFCTagType {
    #if canImport(CoreNFC)
    public typealias Reader = NFCNDEFReader
    public typealias ReaderDetectObject = [NFCNDEFMessage]
    #endif
}

extension NDEFMessage {
    public enum DetectResult: NFCTagTypeDetectResult {
        case success(alertMessage: String?)
        case restartPolling(alertMessage: String?)
        case `continue`
    }
}

extension NDEFMessage.DetectResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
}
