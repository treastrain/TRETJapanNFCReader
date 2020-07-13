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
    
    private var didBecomeActiveHandler: (() -> Void)?
    private var resultHandler: ((Result<Data, Error>) -> Void)?
    
    /// Reading data from Transit IC card
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - delegate: An object that handles callbacks from the reader.
    public func read(itemTypes: [TransitICCardItemType]/*, delegate: TransitICReaderDelegate*/) {
    }
    
    public func read(itemTypes: [TransitICCardItemType], didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        guard NFCReaderSession.readingAvailable,
              let session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self) else {
            resultHandler(.failure(NSError()))
            return
        }
        
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.resultHandler = resultHandler
        
        session.alertMessage = "カードを平らな面に置き、カードの下半分を隠すように iPhone をその上に置いてください。"
        session.begin()
    }
    
    public override func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        self.didBecomeActiveHandler?()
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [TransitICCardItemType]) {}
}

#endif
