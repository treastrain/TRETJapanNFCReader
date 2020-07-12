//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// A reader for Transit IC (comply with CJRC standards, e.g.: Suica, ICOCA, PiTaPa, TOICA, PASMO, nimoca, Kitaca, SUGOCA, はやかけん, manaca, etc.) cards.
@available(iOS 13.0, *)
public class TransitICReader: FeliCaReader {
    
    private init() {
        fatalError()
    }
}

#endif
