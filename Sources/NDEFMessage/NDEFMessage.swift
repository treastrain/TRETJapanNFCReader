//
//  NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFMessage: NFCTagType {
    #if canImport(CoreNFC)
    public typealias ReaderSession = NFCNDEFReaderSession
    public typealias ReaderSessionProtocol = _NDEFMessageOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some NFCNDEFMessageReaderSessionProtocol`
    public typealias ReaderSessionDetectObject = [NFCNDEFMessage]
    #endif
}

extension NDEFMessage {
    public enum DetectResult: Sendable {
        case success(alertMessage: String?)
        case restartPolling(alertMessage: String?)
        case `continue`
    }
}

extension NDEFMessage.DetectResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
}

#if canImport(CoreNFC)
public enum _NDEFMessageOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCNDEFMessageReaderSessionProtocol`, which will not be called from either place.
    public var readerSessionProtocol: some NFCNDEFMessageReaderSessionProtocol {
        NDEFMessage.ReaderSession(delegate: _NFCNDEFReaderSessionOpaqueTypeBuilder(), queue: nil, invalidateAfterFirstRead: false)
    }
}
#endif
