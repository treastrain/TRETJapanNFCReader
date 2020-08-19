//
//  RakutenEdyReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
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

/// A reader for Rakuten Edy cards.
@available(iOS 13.0, *)
public class RakutenEdyReader: FeliCaReader {
    
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var readResultHandler: ((Result<RakutenEdyCardDataResponse, Error>) -> Void)?
    
    public init(delegate: RakutenEdyReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: Configuration = .default) {
        super.init(delegate: delegate, queue: readerQueue, configuration: configuration)
    }
    
    /// Reads data from Rakuten Edy card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: Set<RakutenEdyCardItemType>) {
        self.read(itemTypes, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Reads data from Rakuten Edy card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: [RakutenEdyCardItemType]) {
        self.read(Set(itemTypes))
    }
    
    /// Reads data from Rakuten Edy card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: RakutenEdyCardItemType...) {
        self.read(itemTypes)
    }
    
    /// Reads data from Rakuten Edy card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: Set<RakutenEdyCardItemType>, didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<RakutenEdyCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: Optional(didBecomeActiveHandler), resultHandler: Optional(resultHandler))
    }
    
    /// Reads data from Rakuten Edy card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: [RakutenEdyCardItemType], didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<RakutenEdyCardDataResponse, Error>) -> Void)) {
        self.read(Set(itemTypes), didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    /// Reads data from Rakuten Edy card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: RakutenEdyCardItemType..., didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<RakutenEdyCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    private func read(_ itemTypes: Set<RakutenEdyCardItemType>, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<RakutenEdyCardDataResponse, Error>) -> Void)? = nil) {
        let parameters = self.convertToParameters(from: itemTypes)
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.readResultHandler = resultHandler
        self.readWithoutEncryption(parameters: parameters) { [weak self] in
            if let didBecomeActiveHandler = self?.didBecomeActiveHandler {
                didBecomeActiveHandler()
            } else {
                (self?.feliCaReaderDelegate as? RakutenEdyReaderDelegate)?.readerSessionDidBecomeActive()
            }
        } resultHandler: { [weak self] (response) in
            self?.readerSessionReadWithoutEncryptionDidInvalidate(with: response)
        }
    }
    
    private func parse(from responseData: FeliCaCardDataReadWithoutEncryptionResponse) {
        guard let feliCaSystem = responseData.feliCaData[.common] else {
            let failureResult: Result<RakutenEdyCardDataResponse, Error> = .failure(FeliCaReaderError.notFoundPrimarySystem(pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors))
            if let readResultHandler = self.readResultHandler {
                readResultHandler(failureResult)
            } else {
                (self.feliCaReaderDelegate as? RakutenEdyReaderDelegate)?.readerSessionReadDidInvalidate(with: failureResult)
            }
            return
        }
        let cardData = RakutenEdyCardData(idm: feliCaSystem.idm, systemCode: feliCaSystem.systemCode, data: responseData.feliCaData)
        self.returnReaderSessionReadDidInvalidate(result: .success(RakutenEdyCardDataResponse(cardData: cardData, feliCaData: responseData.feliCaData, pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors)))
    }
    
    public func returnReaderSessionReadDidInvalidate(result: Result<RakutenEdyCardDataResponse, Error>) {
        self.readerQueue.async {
            if let readResultHandler = self.readResultHandler {
                readResultHandler(result)
            } else {
                (self.feliCaReaderDelegate as? RakutenEdyReaderDelegate)?.readerSessionReadDidInvalidate(with: result)
            }
        }
    }
    
    private override init(delegate: FeliCaReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: JapanNFCReader.Configuration = .default) {
        fatalError()
    }
    
    private func convertToParameters(from itemTypes: Set<RakutenEdyCardItemType>) -> Set<FeliCaReadWithoutEncryptionCommandParameter> {
        return itemTypes.setMap { $0.parameter }
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [RakutenEdyCardItemType]) {}
}

@available(iOS 13.0, *)
extension RakutenEdyReader: FeliCaReaderDelegate {
    public func readerSessionReadWithoutEncryptionDidInvalidate(with result: Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) {
        switch result {
        case .success(let responseData):
            self.parse(from: responseData)
        case .failure(let error):
            self.returnReaderSessionReadDidInvalidate(result: .failure(error))
        }
    }
}

#endif
