//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// A reader for Transit IC (comply with CJRC standards, e.g.: Suica, ICOCA, PiTaPa, TOICA, PASMO, nimoca, Kitaca, SUGOCA, はやかけん, manaca, etc.) cards.
@available(iOS 13.0, *)
public class TransitICReader: FeliCaReader {
    
    private var systemCode: FeliCaSystemCode = .cjrc
    private var readResultHandler: ((Result<(TransitICCardData, [FeliCaSystemCode : Error?], [FeliCaSystemCode : [FeliCaServiceCode : Error]]), Error>) -> Void)?
    
    private override init(configuration: Configuration = .default) {
        fatalError()
    }
    
    /// Creates an Transit IC reader.
    /// - Parameter systemCode: FeliCa System Code
    public init(configuration: Configuration = .default, systemCode: FeliCaSystemCode = .cjrc) {
        super.init(configuration: configuration)
        self.systemCode = systemCode
    }
    
    /// Reading data from Transit IC card
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - delegate: An object that handles callbacks from the reader.
    // public func read(itemTypes: [TransitICCardItemType]/*, delegate: TransitICReaderDelegate*/) {
    // }
    
    public func read(_ itemTypes: Set<TransitICCardItemType>, queue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<(TransitICCardData, [FeliCaSystemCode : Error?], [FeliCaSystemCode : [FeliCaServiceCode : Error]]), Error>) -> Void) {
        var itemTypes = itemTypes
        if self.systemCode != .sapica {
            itemTypes = itemTypes.filter { $0 != .sapicaPoints }
        }
        let parameters = itemTypes.setMap { $0.parameter(systemCode: self.systemCode) }
        self.readResultHandler = resultHandler
        
        self.readWithoutEncryption(parameters: parameters, queue: queue, didBecomeActive: didBecomeActiveHandler) { [weak self] response in
            guard let `self` = self else {
                print(#file, #function, "An instance of this class has already been deinited.")
                return
            }
            switch response {
            case .success(let responseData):
                self.parse(from: responseData)
            case .failure(let error):
                print(self, #function, "error", error)
                self.readResultHandler?(.failure(error))
            }
        }
    }
    
    public func read(_ itemTypes: [TransitICCardItemType], queue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<(TransitICCardData, [FeliCaSystemCode : Error?], [FeliCaSystemCode : [FeliCaServiceCode : Error]]), Error>) -> Void) {
        self.read(Set(itemTypes), queue: queue, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    public func read(_ itemTypes: TransitICCardItemType..., queue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<(TransitICCardData, [FeliCaSystemCode : Error?], [FeliCaSystemCode : [FeliCaServiceCode : Error]]), Error>) -> Void) {
        self.read(itemTypes, queue: queue, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    private func parse(from responseData: FeliCaReadWithoutEncryptionResponse) {
        guard let feliCaSystem = responseData.feliCaData[self.systemCode] else {
            self.readResultHandler?(.failure(FeliCaReaderError.notFoundPrimarySystem(pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors)))
            return
        }
        let cardData = TransitICCardData(idm: feliCaSystem.idm, systemCode: self.systemCode, data: responseData.feliCaData)
        self.readResultHandler?(.success((cardData, responseData.pollingErrors, responseData.readErrors)))
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [TransitICCardItemType]) {}
}

#endif
