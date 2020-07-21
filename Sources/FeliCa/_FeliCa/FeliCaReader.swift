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
open class FeliCaReader: JapanNFCReader, JapanNFCReaderDelegate {
    
    private var parameters: Set<FeliCaReadWithoutEncryptionCommandParameter> = []
    private var systemCodes: [FeliCaSystemCode] = []
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
                self.systemCodes.append(parameter.systemCode)
            }
        }
    }
    
    /// Starts the reader, and run Read Without Encryption command defined by FeliCa card specification.
    /// - Parameters:
    ///   - parameters: Parameters (system code, service code and number of blocks) for specifying the block.
    ///   - queue: A dispatch queue that the reader uses when making callbacks to the handler.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    public func readWithoutEncryption(parameters: Set<FeliCaReadWithoutEncryptionCommandParameter>, queue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, JapanNFCReaderError>) -> Void) {
        self.set(parameters)
        self.beginScanning(pollingOption: .iso18092, delegate: self, queue: queue, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didConnect tag: NFCTag) {
        print(self, #function, #line, tag)
        
        guard case .feliCa(let feliCaTag) = tag else {
            session.invalidate(errorMessage: "FeliCa タグではないものが検出されました。")
            self.readerQueue.async {
                self.resultHandler?(.failure(.invalidDetectedTagType))
            }
            return
        }
        
        print("FeliCa タグでした🎉", feliCaTag.currentSystemCode as NSData)
        session.alertMessage = "完了"
        session.invalidate()
        self.readerQueue.async {
            self.resultHandler?(.success(Data()))
        }
    }
}

#endif
