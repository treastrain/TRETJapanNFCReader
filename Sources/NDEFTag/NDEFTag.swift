//
//  NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias ReaderSession = NFCNDEFReaderSession
    public typealias ReaderSessionProtocol = _NDEFTagOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some NFCNDEFTagReaderSessionProtocol`
    public typealias ReaderSessionDetectObject = [any NFCNDEFTag]
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

#if canImport(CoreNFC)
public enum _NDEFTagOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCNDEFTagReaderSessionProtocol`, which will not be called from either place.
    public var readerSessionProtocol: some NFCNDEFTagReaderSessionProtocol {
        NDEFTag.ReaderSession(delegate: _NFCNDEFReaderSessionOpaqueTypeBuilder(), queue: nil, invalidateAfterFirstRead: false)
    }
}
#endif
