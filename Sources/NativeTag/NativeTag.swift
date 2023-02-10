//
//  NativeTag.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/20.
//

public enum NativeTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias ReaderSession = NFCTagReaderSession
    public typealias ReaderSessionProtocol = _NativeTagOpaqueTypeBuilder.ReaderSessionProtocol // it means like `some NFCNativeTagReaderSessionProtocol`
    public typealias ReaderSessionDetectObject = [NFCTag]
    #endif
}

extension NativeTag {
    public enum DetectResult: Sendable {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
    }
}

extension NativeTag.DetectResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}

#if canImport(CoreNFC)
public enum _NativeTagOpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCNativeTagReaderSessionProtocol`, which will not be called from either place.
    public var readerSessionProtocol: some NFCNativeTagReaderSessionProtocol {
        NativeTag.ReaderSession(pollingOption: [], delegate: _NFCTagReaderSessionOpaqueTypeBuilder())!
    }
}
#endif
