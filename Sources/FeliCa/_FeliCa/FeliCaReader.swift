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

/// The abstract base class that represents a FeliCa (ISO 18092, NFC-F) reader.
@available(iOS 13.0, *)
open class FeliCaReader: JapanNFCReader {
    
    /// The delegate of the reader.
    public private(set) var feliCaReaderDelegate: FeliCaReaderDelegate? = nil
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var readWithoutEncryptionResultHandler: ((Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) -> Void)?
    
    private var parameters: Set<FeliCaReadWithoutEncryptionCommandParameter> = []
    private var systemCodes: Set<FeliCaSystemCode> = []
    private var serviceCodes: [FeliCaSystemCode : [(serviceCode: FeliCaServiceCode, numberOfBlock: Int)]] = [:]
    
    /// Creates a reader with the specified session configuration, delegate, and reader queue.
    /// - Parameters:
    ///   - configuration: A configuration object. See `JapanNFCReader.Configuration` for more information.
    ///   - delegate: A reader delegate object that handles reader-related events. If nil, the class should be used only with methods that take result handlers.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    public init(configuration: Configuration = .default, delegate: FeliCaReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main) {
        self.feliCaReaderDelegate = delegate
        super.init(configuration: configuration, delegate: nil, queue: readerQueue)
    }
    
    private func set(_ parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>) {
        self.parameters = parameters
        self.systemCodes.removeAll()
        self.serviceCodes.removeAll()
        
        for parameter in parameters {
            if self.systemCodes.contains(parameter.systemCode) {
                self.serviceCodes[parameter.systemCode]?.append((serviceCode: parameter.serviceCode, numberOfBlock: parameter.numberOfBlock))
            } else {
                self.serviceCodes[parameter.systemCode] = [(serviceCode: parameter.serviceCode, numberOfBlock: parameter.numberOfBlock)]
                self.systemCodes.insert(parameter.systemCode)
            }
        }
    }
    
    /// Starts the reader, and run Read Without Encryption command defined by FeliCa card specification.
    /// - Parameter parameters: Parameters (system code, service code and number of blocks) for specifying the block.
    open func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>) {
        self.readWithoutEncryption(parameters: parameters, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Starts the reader, and run Read Without Encryption command defined by FeliCa card specification, then calls a handler upon completion.
    /// - Parameters:
    ///   - parameters: Parameters (system code, service code and number of blocks) for specifying the block.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    open func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>, didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping (Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) -> Void) {
        self.readWithoutEncryption(parameters: parameters, didBecomeActive: Optional(didBecomeActiveHandler), resultHandler: Optional(resultHandler))
    }
    
    private func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) -> Void)? = nil) {
        self.set(parameters)
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.readWithoutEncryptionResultHandler = resultHandler
        self.beginScanning(pollingOption: .iso18092)
    }
    
    open func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>, session: NFCTagReaderSession, didConnect feliCaTag: NFCFeliCaTag, resultHandler: @escaping (Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) -> Void) {
        self.set(parameters)
        self.didBecomeActiveHandler = nil
        self.readWithoutEncryptionResultHandler = resultHandler
        self.readWithoutEncryption(session, didConnect: feliCaTag)
    }
    
    private func readWithoutEncryption(_ session: NFCTagReaderSession, didConnect tag: NFCTag) {
        // print(self, #function, #line, tag)
        
        guard case .feliCa(let feliCaTag) = tag else {
            session.invalidateByReader(errorMessage: "FeliCa タグではないものが検出されました。")
            self.returnResultDelegateOrHandler(result: .failure(JapanNFCReaderError.invalidDetectedTagType))
            return
        }
        
        print("FeliCa タグでした🎉", feliCaTag.currentSystemCode as NSData)
        self.readWithoutEncryption(session, didConnect: feliCaTag)
    }
    
    private func readWithoutEncryption(_ session: NFCTagReaderSession, didConnect feliCaTag: NFCFeliCaTag) {
        print(self, #function, #line, feliCaTag)
        
        var errorMessage: String? = nil
        var feliCaData: FeliCaData = [:]
        var pollingErrors: [FeliCaSystemCode : Error?] = [:]
        var readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]] = [:]
        
        systemCodeLoop: for systemCode in self.systemCodes {
            var currentPMm: Data
            let result = feliCaTag.polling(systemCode: systemCode.bigEndian.data, requestCode: .systemCode, timeSlot: .max1)
            switch result {
            case .success(let pollingResponse):
                guard systemCode.bigEndian.data == pollingResponse.requestData else {
                    feliCaData[systemCode] = FeliCaSystem(systemCode: systemCode, idm: "", pmm: pollingResponse.manufactureParameter.hexString, services: [:])
                    continue
                }
                currentPMm = pollingResponse.manufactureParameter
            case .failure(let error):
                if !self.configuration.continuesProcessIfErrorOccurred {
                    errorMessage = error.localizedDescription
                    self.returnResultDelegateOrHandler(result: .failure(error))
                    break systemCodeLoop
                }
                pollingErrors[systemCode] = error
                continue
            }
            
            var services: [FeliCaServiceCode : FeliCaBlockData] = [:]
            let serviceCodeData = self.serviceCodes[systemCode]!
            for (serviceCode, numberOfBlock) in serviceCodeData {
                let blockList = (0..<numberOfBlock).map { (block) -> Data in
                    Data([0x80, UInt8(block)])
                }
                let result = feliCaTag.readWithoutEncryption36(serviceCode: serviceCode.data, blockList: blockList)
                switch result {
                case .success((let statusFlag, let blockData)):
                services[serviceCode] = FeliCaBlockData(statusFlag: statusFlag, blockData: blockData)
                case .failure(let error):
                    if !self.configuration.continuesProcessIfErrorOccurred {
                        errorMessage = error.localizedDescription
                        self.returnResultDelegateOrHandler(result: .failure(error))
                        break systemCodeLoop
                    }
                    if readErrors[systemCode] != nil {
                        readErrors[systemCode]![serviceCode] = error
                    } else {
                        readErrors[systemCode] = [serviceCode : error]
                    }
                }
            }
            
            feliCaData[systemCode] = FeliCaSystem(systemCode: systemCode, idm: feliCaTag.currentIDm.hexString, pmm: currentPMm.hexString, services: services)
        }
        
        session.alertMessage = "完了"
        session.invalidateByReader(errorMessage: errorMessage)
        if errorMessage != nil {
            self.returnReaderSessionReadWithoutEncryptionDidInvalidate(result: .success(FeliCaCardDataReadWithoutEncryptionResponse(feliCaData: feliCaData, pollingErrors: pollingErrors, readErrors: readErrors)))
        }
    }
    
    public func returnReaderSessionReadWithoutEncryptionDidInvalidate(result: Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) {
        self.readerQueue.async {
            if let readWithoutEncryptionResultHandler = self.readWithoutEncryptionResultHandler {
                readWithoutEncryptionResultHandler(result)
            } else {
                self.feliCaReaderDelegate?.readerSessionReadWithoutEncryptionDidInvalidate(with: result)
            }
        }
    }
}

@available(iOS 13.0, *)
extension FeliCaReader: JapanNFCReaderDelegate {
    public func readerSessionDidBecomeActive() {
        if let didBecomeActiveHandler = self.didBecomeActiveHandler {
            didBecomeActiveHandler()
        } else {
            self.feliCaReaderDelegate?.readerSessionDidBecomeActive()
        }
    }
    
    public func readerSessionDidInvalidate(with result: Result<(NFCTagReaderSession, NFCTag), Error>) {
        switch result {
        case .success((let session, let tag)):
            self.readWithoutEncryption(session, didConnect: tag)
        case .failure(let error):
            if let readWithoutEncryptionResultHandler = self.readWithoutEncryptionResultHandler {
                readWithoutEncryptionResultHandler(.failure(error))
            } else {
                self.feliCaReaderDelegate?.readerSessionReadWithoutEncryptionDidInvalidate(with: .failure(error))
            }
        }
    }
}

#endif
