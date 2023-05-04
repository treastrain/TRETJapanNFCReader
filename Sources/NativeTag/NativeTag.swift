//
//  NativeTag.swift
//  NativeTag
//
//  Created by treastrain on 2022/09/20.
//

public enum NativeTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias Reader = NFCTagReader
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
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}
