//
//  NDEFStatus.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation

/// Constants that indicate status for an NDEF tag.
public enum NDEFStatus: UInt {
    /// Tag is not NDEF formatted; NDEF read and write are disallowed.
    case notSupported = 1
    /// Tag is NDEF read and writable.
    case readWrite = 2
    /// Tag is NDEF read-only; NDEF writing is disallowed.
    case readOnly = 3
}
