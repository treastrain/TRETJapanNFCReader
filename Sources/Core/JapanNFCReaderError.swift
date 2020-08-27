//
//  JapanNFCReaderError.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/09.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
public enum JapanNFCReaderError: Error {
    /// It was false that `NFCTagReaderSession.readingAvailable` which the Boolean value that determines whether the device supports NFC tag reading.
    case readingUnavailable
    /// `NFCTagReaderSession.init(pollingOption:delegate:queue:)` was `nil` and could not be created.
    case couldNotCreateTagReaderSession
    /// The detected tag type is invalid because it is an unspecified type.
    case invalidDetectedTagType
    
    /// An error that occurred in `NFCTagReaderSessionDelegate.tagReaderSession(_:didInvalidateWithError:)` method.
    case tagReaderSessionDidInvalidateWithError(_ nfcReaderError: Error)
    /// An error that occurred in `NFCTagReaderSession.connect(to:completionHandler:)` method.
    case tagReaderSessionConnectError(_ nfcReaderError: Error)
}

@available(iOS 13.0, *)
extension JapanNFCReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .readingUnavailable:
            return "NFC Tag Reading is unavailable."
        case .couldNotCreateTagReaderSession:
            return nil
        case .invalidDetectedTagType:
            return nil
        case .tagReaderSessionDidInvalidateWithError(_):
            return "The reader session has invalid."
        case .tagReaderSessionConnectError(_):
            return nil
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .readingUnavailable:
            return "This device does not support NFC tag reading."
        case .couldNotCreateTagReaderSession:
            return nil
        case .invalidDetectedTagType:
            return nil
        case .tagReaderSessionDidInvalidateWithError(let error):
            let nfcReaderError = error as? NFCReaderError
            return nfcReaderError?.localizedDescription
        case .tagReaderSessionConnectError(_):
            return nil
        }
    }
}

#endif
