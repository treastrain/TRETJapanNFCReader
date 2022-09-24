//
//  NativeTag.swift
//  Core
//
//  Created by treastrain on 2022/09/20.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public enum NativeTag: NFCTagType {
    #if canImport(CoreNFC)
    public typealias ReaderSession = NFCTagReaderSession
    public typealias ReaderSessionAlertMessageable = NFCNativeTagReaderSessionAlertMessageable
    public typealias ReaderSessionProtocol = NFCNativeTagReaderSessionProtocol
    public typealias ReaderSessionDetectObject = [NFCTag]
    #endif
}

#if canImport(CoreNFC)
extension NativeTag.ReaderSession: NFCReaderSessionDelegatable {
    public typealias CallbackHandleObject = NFCTagReaderSessionDelegate
}
#endif

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
