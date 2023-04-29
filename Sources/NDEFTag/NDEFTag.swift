//
//  NDEFTag.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/23.
//

public enum NDEFTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias Reader = NFCNDEFReader
    public typealias ReaderProtocol = _OpaqueTypeBuilder.ReaderProtocol // it means like `some NFCNDEFTagReaderProtocol`
    public typealias ReaderDetectObject = [any NFCNDEFTag]
    #endif
}

extension NDEFTag {
    public enum DetectResult: NFCTagTypeFailableDetectResult {
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
extension NDEFTag {
    public enum _OpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `ReaderProtocol` to `some NFCNDEFTagReaderProtocol`, which will not be called from either place.
        public var readerProtocol: some NFCNDEFTagReaderProtocol {
            NDEFTag.Reader(delegate: { fatalError("Do not call this property.") }(), taskPriority: nil, invalidateAfterFirstRead: false)
        }
    }
}
#endif
