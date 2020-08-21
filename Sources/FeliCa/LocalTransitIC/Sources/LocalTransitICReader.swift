//
//  LocalTransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/21.
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

/// A reader for Local Transit IC cards.
@available(iOS 13.0, *)
public class LocalTransitICReader: FeliCaReader {
    
    private let systemCode: FeliCaSystemCode
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var readResultHandler: ((Result<LocalTransitICCardDataResponse, Error>) -> Void)?
    
    /// Creates an Local Transit IC reader with the specified session configuration, delegate, and reader queue.
    /// - Parameters:
    ///   - systemCode: FeliCa System Code.
    ///   - delegate: A reader delegate object that handles reader-related events. If nil, the class should be used only with methods that take result handlers.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    ///   - configuration: A configuration object. See `JapanNFCReader.Configuration` for more information.
    public init(systemCode: FeliCaSystemCode, delegate: LocalTransitICReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: Configuration = .default) {
        self.systemCode = systemCode
        super.init(delegate: delegate, queue: readerQueue, configuration: configuration)
    }
    
    /// Reads data from Local Transit IC card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: Set<LocalTransitICCardItemType>) {
        self.read(itemTypes, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Reads data from Local Transit IC card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: [LocalTransitICCardItemType]) {
        self.read(Set(itemTypes))
    }
    
    /// Reads data from Local Transit IC card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: LocalTransitICCardItemType...) {
        self.read(itemTypes)
    }
    
    /// Reads data from Local Transit IC card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: Set<LocalTransitICCardItemType>, didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<LocalTransitICCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: Optional(didBecomeActiveHandler), resultHandler: Optional(resultHandler))
    }
    
    /// Reads data from Local Transit IC card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: [LocalTransitICCardItemType], didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<LocalTransitICCardDataResponse, Error>) -> Void)) {
        self.read(Set(itemTypes), didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    /// Reads data from Local Transit IC card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: LocalTransitICCardItemType..., didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<LocalTransitICCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    private func read(_ itemTypes: Set<LocalTransitICCardItemType>, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<LocalTransitICCardDataResponse, Error>) -> Void)? = nil) {
        let parameters = self.convertToParameters(from: itemTypes)
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.readResultHandler = resultHandler
        self.readWithoutEncryption(parameters: parameters) { [weak self] in
            if let didBecomeActiveHandler = self?.didBecomeActiveHandler {
                didBecomeActiveHandler()
            } else {
                (self?.feliCaReaderDelegate as? LocalTransitICReaderDelegate)?.readerSessionDidBecomeActive()
            }
        } resultHandler: { [weak self] (response) in
            self?.readerSessionReadWithoutEncryptionDidInvalidate(with: response)
        }
    }
    
    private func parse(from responseData: FeliCaCardDataReadWithoutEncryptionResponse) {
        guard let feliCaSystem = responseData.feliCaData[self.systemCode] else {
            let failureResult: Result<LocalTransitICCardDataResponse, Error> = .failure(FeliCaReaderError.notFoundPrimarySystem(pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors))
            if let readResultHandler = self.readResultHandler {
                readResultHandler(failureResult)
            } else {
                (self.feliCaReaderDelegate as? LocalTransitICReaderDelegate)?.readerSessionReadDidInvalidate(with: failureResult)
            }
            return
        }
        let cardData = LocalTransitICCardData(idm: feliCaSystem.idm, systemCode: self.systemCode, data: responseData.feliCaData)
        self.returnReaderSessionReadDidInvalidate(result: .success(LocalTransitICCardDataResponse(cardData: cardData, feliCaData: responseData.feliCaData, pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors)))
    }
    
    public func returnReaderSessionReadDidInvalidate(result: Result<LocalTransitICCardDataResponse, Error>) {
        self.readerQueue.async {
            if let readResultHandler = self.readResultHandler {
                readResultHandler(result)
            } else {
                (self.feliCaReaderDelegate as? LocalTransitICReaderDelegate)?.readerSessionReadDidInvalidate(with: result)
            }
        }
    }
    
    private override init(delegate: FeliCaReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: JapanNFCReader.Configuration = .default) {
        fatalError()
    }
    
    private func convertToParameters(from itemTypes: Set<LocalTransitICCardItemType>) -> Set<FeliCaReadWithoutEncryptionCommandParameter> {
        return itemTypes.setMap { $0.parameter(systemCode: self.systemCode) }
    }
    
    @available(*, unavailable, renamed: "read")
    public func get(itemTy pes: [RyutoCardItemType]) {}
}

@available(iOS 13.0, *)
extension LocalTransitICReader: FeliCaReaderDelegate {
    public func readerSessionReadWithoutEncryptionDidInvalidate(with result: Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) {
        switch result {
        case .success(let responseData):
            self.parse(from: responseData)
        case .failure(let error):
            self.returnReaderSessionReadDidInvalidate(result: .failure(error))
        }
    }
}

@available(iOS, introduced: 13.0, unavailable, renamed: "LocalTransitICReader")
public typealias RyutoReader = LocalTransitICReader

#endif
