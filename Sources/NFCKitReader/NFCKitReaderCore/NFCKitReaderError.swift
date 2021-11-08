//
//  NFCKitReaderError.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

import NFCKitCore

public enum NFCKitReaderError: Error {
    /// [`NFCTagReaderSession.readingAvailable`](https://developer.apple.com/documentation/corenfc/nfcreadersession/3043845-readingavailable) is `false`.
    case readingUnavailable
    /// Could not initialize the reader session due to unavailability of system memory resources.
    case systemMemoryResourcesAreUnavailable
    /// Cannot start scanning because the PIN does not meet the required format.
    case notStartedScanBecausePINFormatInvalid
}

extension NFCKitReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .readingUnavailable:
            return "This device does not support scanning for and detecting NFC tags."
        case .systemMemoryResourcesAreUnavailable:
            return "Could not initialize the reader session due to unavailability of system memory resources."
        case .notStartedScanBecausePINFormatInvalid:
            return "Cannot start scanning because the PIN does not meet the required format."
        }
    }
}
