//
//  NativeTag.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/20.
//

public enum NativeTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias Reader = NFCTagReader
    public typealias ReaderProtocol = _OpaqueTypeBuilder.ReaderProtocol // it means like `some NFCNativeTagReaderProtocol`
    public typealias ReaderDetectObject = [NFCTag]
    #endif
}

extension NativeTag {
    public enum DetectResult: NFCTagTypeFailableDetectResult {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
    }
}

extension NativeTag.DetectResult {
    public static let success: Self = .success(alertMessage: nil)
    public static let restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: any Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}

#if canImport(CoreNFC)
extension NativeTag {
    public enum _OpaqueTypeBuilder: _NFCTagTypeOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `ReaderProtocol` to `some NFCNativeTagReaderProtocol`, which will not be called from either place.
        public var readerProtocol: some NFCNativeTagReaderProtocol {
            NativeTag.Reader(pollingOption: [], delegate: { fatalError("Do not call this property.") }())!
        }
    }
}
#endif
