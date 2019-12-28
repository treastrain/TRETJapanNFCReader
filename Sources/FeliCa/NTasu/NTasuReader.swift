//
//  NTasuReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias NTasuCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class NTasuReader: FeliCaReader {
    
    private var nTasuCardItemTypes: [NTasuCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
}

#endif
