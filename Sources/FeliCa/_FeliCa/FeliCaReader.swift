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
    
    public private(set) var readWithoutEncryptionResultHandler: ((Result<FeliCaReadWithoutEncryptionResponse, FeliCaReaderError>) -> Void)?
    
    private var parameters: Set<FeliCaReadWithoutEncryptionCommandParameter> = []
    private var systemCodes: Set<FeliCaSystemCode> = []
    private var serviceCodes: [FeliCaSystemCode : [(serviceCode: FeliCaServiceCode, numberOfBlock: Int)]] = [:]
    
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
    /// - Parameters:
    ///   - parameters: Parameters (system code, service code and number of blocks) for specifying the block.
    ///   - queue: A dispatch queue that the reader uses when making callbacks to the handler.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>, queue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<FeliCaReadWithoutEncryptionResponse, FeliCaReaderError>) -> Void) {
        self.set(parameters)
        self.readWithoutEncryptionResultHandler = resultHandler
        let superResultHandler: ((Result<(NFCTagReaderSession, NFCTag), JapanNFCReaderError>) -> Void) = { [weak self] response in
            guard let `self` = self else {
                print(#file, #function, "An instance of this class has already been deinited.")
                return
            }
            switch response {
            case .success((let session, let tag)):
                self.readWithoutEncryption(session, didConnect: tag)
            case .failure(let error):
                self.readWithoutEncryptionResultHandler?(.failure(.japanNFCReaderError(error)))
            }
        }
        
        self.beginScanning(pollingOption: .iso18092, queue: queue, didBecomeActive: didBecomeActiveHandler, resultHandler: superResultHandler)
    }
    
    private func readWithoutEncryption(_ session: NFCTagReaderSession, didConnect tag: NFCTag) {
        // print(self, #function, #line, tag)
        
        guard case .feliCa(let feliCaTag) = tag else {
            session.invalidate(errorMessage: "FeliCa タグではないものが検出されました。")
            self.readerQueue.async {
                self.resultHandler?(.failure(.invalidDetectedTagType))
            }
            return
        }
        
        print("FeliCa タグでした🎉", feliCaTag.currentSystemCode as NSData)
        
        var feliCaData: FeliCaData = [:]
        var pollingErrors: [FeliCaSystemCode : Error?] = [:]
        var readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]] = [:]
        
        for systemCode in self.systemCodes {
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
        session.invalidateSuccessfully()
        self.readerQueue.async {
            self.readWithoutEncryptionResultHandler?(.success(FeliCaReadWithoutEncryptionResponse(feliCaData: feliCaData, pollingErrors: pollingErrors, readErrors: readErrors)))
        }
    }
}

#endif
