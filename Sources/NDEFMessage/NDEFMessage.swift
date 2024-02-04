//
//  NDEFMessage.swift
//  NDEFMessage
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFMessage: NFCTagType {
    #if canImport(CoreNFC)
    public typealias Reader = NFCNDEFReader
    public typealias ReaderProtocol = _OpaqueTypeBuilder.ReaderProtocol // it means like `some NFCNDEFMessageReaderProtocol`
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
    public static let success: Self = .success(alertMessage: nil)
    public static let restartPolling: Self = .restartPolling(alertMessage: nil)
}

#if canImport(CoreNFC)
extension NDEFMessage {
    public enum _OpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `ReaderProtocol` to `some NFCNDEFMessageReaderProtocol`, which will not be called from either place.
        public var readerProtocol: some NFCNDEFMessageReaderProtocol {
            NDEFMessage.Reader(delegate: { fatalError("Do not call this property.") }(), taskPriority: nil, invalidateAfterFirstRead: false)
        }
    }
}
#endif
