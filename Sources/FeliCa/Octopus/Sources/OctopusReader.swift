//
//  OctopusReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
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

/// A reader for Octopus cards.
@available(iOS 13.0, *)
public class OctopusReader: FeliCaReader {
    
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var readResultHandler: ((Result<OctopusCardDataResponse, Error>) -> Void)?
    
    /// A Boolean value indicating whether to support reading older Octopus cards (issued before 2004).
    private var isSupportedPre2004 = false
    
    /// Creates an Octopus reader with the specified session configuration, delegate, and reader queue.
    /// - Parameters:
    ///   - isSupportedPre2004: A Boolean value indicating whether to support reading older Octopus cards (issued before 2004).
    ///   - delegate: A reader delegate object that handles reader-related events. If nil, the class should be used only with methods that take result handlers.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    ///   - configuration: A configuration object. See `JapanNFCReader.Configuration` for more information.
    public init(isSupportedPre2004: Bool = false, delegate: OctopusReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: Configuration = .default) {
        super.init(delegate: delegate, queue: readerQueue, configuration: configuration)
        self.isSupportedPre2004 = isSupportedPre2004
    }
    
    /// Reads data from Octopus card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: Set<OctopusCardItemType>) {
        self.read(itemTypes, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Reads data from Octopus card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: [OctopusCardItemType]) {
        self.read(Set(itemTypes))
    }
    
    /// Reads data from Octopus card.
    /// - Parameter itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    public func read(_ itemTypes: OctopusCardItemType...) {
        self.read(itemTypes)
    }
    
    /// Reads data from Octopus card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: Set<OctopusCardItemType>, didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<OctopusCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: Optional(didBecomeActiveHandler), resultHandler: Optional(resultHandler))
    }
    
    /// Reads data from Octopus card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: [OctopusCardItemType], didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<OctopusCardDataResponse, Error>) -> Void)) {
        self.read(Set(itemTypes), didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    /// Reads data from Octopus card, then calls a handler upon completion.
    /// - Parameters:
    ///   - itemTypes: Configures the item type of the reader; multiple types can be OR’ed together.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func read(_ itemTypes: OctopusCardItemType..., didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping ((Result<OctopusCardDataResponse, Error>) -> Void)) {
        self.read(itemTypes, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    private func read(_ itemTypes: Set<OctopusCardItemType>, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<OctopusCardDataResponse, Error>) -> Void)? = nil) {
        let parameters = self.convertToParameters(from: itemTypes)
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.readResultHandler = resultHandler
        
        if self.isSupportedPre2004 {
            self.readForPre2004(parameters: parameters)
        } else {
            self.readWithoutEncryption(parameters: parameters) { [weak self] in
                if let didBecomeActiveHandler = self?.didBecomeActiveHandler {
                    didBecomeActiveHandler()
                } else {
                    (self?.feliCaReaderDelegate as? OctopusReaderDelegate)?.readerSessionDidBecomeActive()
                }
            } resultHandler: { [weak self] (response) in
                self?.readerSessionReadWithoutEncryptionDidInvalidate(with: response)
            }
        }
    }
    
    private func readForPre2004(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>) {
        self.beginScanning { [weak self] in
            if let didBecomeActiveHandler = self?.didBecomeActiveHandler {
                didBecomeActiveHandler()
            } else {
                (self?.feliCaReaderDelegate as? OctopusReaderDelegate)?.readerSessionDidBecomeActive()
            }
        } resultHandler: { [weak self] (response) in
            switch response {
            case .success((let session, let tag)):
                guard case .feliCa(let feliCaTag) = tag else {
                    session.invalidateByReader(errorMessage: "FeliCa タグではないものが検出されました。")
                    self?.returnResultDelegateOrHandler(result: .failure(JapanNFCReaderError.invalidDetectedTagType))
                    return
                }
                
                var errorMessage: String? = nil
                var feliCaData: FeliCaData = [:]
                let systemCode = FeliCaSystemCode.octopus
                var readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]] = [:]
                var services: [FeliCaServiceCode : FeliCaBlockData] = [:]
                let serviceCodeData = parameters.map { (serviceCode: $0.serviceCode, numberOfBlock: $0.numberOfBlock) }
                for (serviceCode, numberOfBlock) in serviceCodeData {
                    let blockList = (0..<numberOfBlock).map { (block) -> Data in
                        Data([0x80, UInt8(block)])
                    }
                    let result = feliCaTag.readWithoutEncryption36(serviceCode: serviceCode.data, blockList: blockList)
                    switch result {
                    case .success((let statusFlag, let blockData)):
                        services[serviceCode] = FeliCaBlockData(statusFlag: statusFlag, blockData: blockData)
                    case .failure(let error):
                        if !(self?.configuration.continuesProcessIfErrorOccurred ?? false) {
                            errorMessage = error.localizedDescription
                            self?.returnResultDelegateOrHandler(result: .failure(error))
                            break
                        }
                        if readErrors[systemCode] != nil {
                            readErrors[systemCode]![serviceCode] = error
                        } else {
                            readErrors[systemCode] = [serviceCode : error]
                        }
                    }
                }
                feliCaData[systemCode] = FeliCaSystem(systemCode: systemCode, idm: feliCaTag.currentIDm.hexString, pmm: "PMm is not read if `isSupportedPre2004` is `true`", services: services)
                
                session.alertMessage = "Done"
                session.invalidateByReader(errorMessage: errorMessage)
                self?.readerSessionReadWithoutEncryptionDidInvalidate(with: .success(FeliCaCardDataReadWithoutEncryptionResponse(feliCaData: feliCaData, pollingErrors: [:], readErrors: readErrors)))
            case .failure(let error):
                self?.returnReaderSessionReadDidInvalidate(result: .failure(error))
            }
        }
    }
    
    private func parse(from responseData: FeliCaCardDataReadWithoutEncryptionResponse) {
        guard let feliCaSystem = responseData.feliCaData[.octopus] else {
            let failureResult: Result<OctopusCardDataResponse, Error> = .failure(FeliCaReaderError.notFoundPrimarySystem(pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors))
            if let readResultHandler = self.readResultHandler {
                readResultHandler(failureResult)
            } else {
                (self.feliCaReaderDelegate as? OctopusReaderDelegate)?.readerSessionReadDidInvalidate(with: failureResult)
            }
            return
        }
        let cardData = OctopusCardData(idm: feliCaSystem.idm, systemCode: .octopus, data: responseData.feliCaData)
        self.returnReaderSessionReadDidInvalidate(result: .success(OctopusCardDataResponse(cardData: cardData, feliCaData: responseData.feliCaData, pollingErrors: responseData.pollingErrors, readErrors: responseData.readErrors)))
    }
    
    public func returnReaderSessionReadDidInvalidate(result: Result<OctopusCardDataResponse, Error>) {
        self.readerQueue.async {
            if let readResultHandler = self.readResultHandler {
                readResultHandler(result)
            } else {
                (self.feliCaReaderDelegate as? OctopusReaderDelegate)?.readerSessionReadDidInvalidate(with: result)
            }
        }
    }
    
    private override init(delegate: FeliCaReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: JapanNFCReader.Configuration = .default) {
        fatalError()
    }
    
    private func convertToParameters(from itemTypes: Set<OctopusCardItemType>) -> Set<FeliCaReadWithoutEncryptionCommandParameter> {
        return itemTypes.setMap { $0.parameter }
    }
    
    /// Get read data from Octopus card
    /// - Parameter itemTypes: Types of data items you want to read from Octopus card
    @available(*, unavailable, renamed: "read")
    public func get(itemTypes: [OctopusCardItemType]) {}
}

@available(iOS 13.0, *)
extension OctopusReader: FeliCaReaderDelegate {
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
