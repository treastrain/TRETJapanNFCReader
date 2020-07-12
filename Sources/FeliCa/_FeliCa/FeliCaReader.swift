//
//  FeliCaReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
/// The abstract base class that represents a FeliCa (ISO 18092, NFC-F) reader.
open class FeliCaReader: JapanNFCReader {
    
    private override init() {
        fatalError()
    }
}

#endif
