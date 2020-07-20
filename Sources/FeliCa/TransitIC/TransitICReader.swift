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
    
    private var systemCode: FeliCaSystemCode = .cjrc
    
    /// Creates an Transit IC reader.
    /// - Parameter systemCode: FeliCa System Code
    public init(systemCode: FeliCaSystemCode = .cjrc) {
        self.systemCode = systemCode
    }
    
    /// Reading data from Transit IC card
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - delegate: An object that handles callbacks from the reader.
    // public func read(itemTypes: [TransitICCardItemType]/*, delegate: TransitICReaderDelegate*/) {
    // }
    
    public func read(_ itemTypes: [TransitICCardItemType], didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        var itemTypes = itemTypes
        if self.systemCode != .sapica {
            itemTypes = itemTypes.filter { $0 != .sapicaPoints }
        }
        let parameters = itemTypes.map { $0.parameter(systemCode: self.systemCode) }
        
        self.readWithoutEncryption(parameters: parameters, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    public func read(_ itemTypes: TransitICCardItemType..., didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        self.read(itemTypes, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [TransitICCardItemType]) {}
}

#endif
