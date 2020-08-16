//
//  UnivCoopICPrepaidReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
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

/// A reader for Japanese Univ. Co-op IC Prepaid cards.
@available(iOS 13.0, *)
public class UnivCoopICPrepaidReader: FeliCaReader {
    
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var readResultHandler: ((Result<UnivCoopICPrepaidCardDataResponse, Error>) -> Void)?
    
    public init(delegate: UnivCoopICPrepaidReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: Configuration = .default) {
        super.init(delegate: delegate, queue: readerQueue, configuration: configuration)
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: Set<UnivCoopICPrepaidCardItemType>) {
        self.read(itemTypes, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: [UnivCoopICPrepaidCardItemType]) {
        self.read(Set(itemTypes))
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: UnivCoopICPrepaidCardItemType...) {
        self.read(itemTypes)
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: Set<UnivCoopICPrepaidCardItemType>, didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<UnivCoopICPrepaidCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: Optional(didBecomeActiveHandler), resultHandler: Optional(resultHandler))
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: [UnivCoopICPrepaidCardItemType], didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<UnivCoopICPrepaidCardDataResponse, Error>) -> Void)) {
        self.read(Set(itemTypes), didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    /// Reads data from Japanese Univ. Co-op IC Prepaid card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: UnivCoopICPrepaidCardItemType..., didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<UnivCoopICPrepaidCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    private func read(_ itemTypes: Set<UnivCoopICPrepaidCardItemType>, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<UnivCoopICPrepaidCardDataResponse, Error>) -> Void)? = nil) {
        let parameters = self.convertToParameters(from: itemTypes)
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.readResultHandler = resultHandler
        self.readWithoutEncryption(parameters: parameters) { [weak self] in
            if let didBecomeActiveHandler = self?.didBecomeActiveHandler {
                didBecomeActiveHandler()
            } else {
                (self?.feliCaReaderDelegate as? UnivCoopICPrepaidReaderDelegate)?.readerSessionDidBecomeActive()
            }
        } resultHandler: { [weak self] (response) in
            self?.readerSessionReadWithoutEncryptionDidInvalidate(with: response)
        }
    }
    
    private func parse(from responseData: FeliCaCardDataReadWithoutEncryptionResponse) {
        guard let feliCaSystem = responseData.feliCaData[.common] else {
            let failureResult: Result<UnivCoopICPrepaidCardDataResponse, Error> = .failure(FeliCaReaderError.notFoundPrimarySystem(pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors))
            if let readResultHandler = self.readResultHandler {
                readResultHandler(failureResult)
            } else {
                (self.feliCaReaderDelegate as? UnivCoopICPrepaidReaderDelegate)?.readerSessionReadDidInvalidate(with: failureResult)
            }
            return
        }
        let cardData = UnivCoopICPrepaidCardData(idm: feliCaSystem.idm, systemCode: feliCaSystem.systemCode, data: responseData.feliCaData)
        self.returnReaderSessionReadDidInvalidate(result: .success(UnivCoopICPrepaidCardDataResponse(cardData: cardData, feliCaData: responseData.feliCaData, pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors)))
    }
    
    public func returnReaderSessionReadDidInvalidate(result: Result<UnivCoopICPrepaidCardDataResponse, Error>) {
        self.readerQueue.async {
            if let readResultHandler = self.readResultHandler {
                readResultHandler(result)
            } else {
                (self.feliCaReaderDelegate as? UnivCoopICPrepaidReaderDelegate)?.readerSessionReadDidInvalidate(with: result)
            }
        }
    }
    
    private override init(delegate: FeliCaReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: JapanNFCReader.Configuration = .default) {
        fatalError()
    }
    
    private func convertToParameters(from itemTypes: Set<UnivCoopICPrepaidItemType>) -> Set<FeliCaReadWithoutEncryptionCommandParameter> {
        return itemTypes.setMap { $0.parameter }
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [UnivCoopICPrepaidItemType]) { }
}

@available(iOS 13.0, *)
extension UnivCoopICPrepaidReader: FeliCaReaderDelegate {
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
