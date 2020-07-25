//
//  FeliCaReaderError.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/25.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
public enum FeliCaReaderError: Error {
    /// The primary FeliCa system was not found.
    case notFoundPrimarySystem(pollingErrors: [FeliCaSystemCode : Error?], readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]])
    
    /// An error that occurred by `JapanNFCReaderError`.
    case japanNFCReaderError(_ error: JapanNFCReaderError)
}
