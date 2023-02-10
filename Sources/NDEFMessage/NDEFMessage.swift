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
public class _NDEFMessageOpaqueTypeBuilder: NSObject, _NFCTagTypeOpaqueTypeBuilderProtocol, NFCNDEFReaderSessionDelegate {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCNDEFMessageReaderSessionProtocol`, which will not be called from either place.
    public var readerSessionProtocol: some NFCNDEFMessageReaderSessionProtocol {
        NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {}
    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}
}
#endif
