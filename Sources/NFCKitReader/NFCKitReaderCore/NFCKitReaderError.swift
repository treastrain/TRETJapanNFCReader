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
    /// PIN が指定の形式を満たしていないため、スキャンを開始できません
    case notStartedScanBecausePINFormatInvalid
}
