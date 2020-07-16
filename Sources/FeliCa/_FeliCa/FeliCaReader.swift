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
    
    public override init() {
        super.init()
        super.delegate = self
    }
    
    public func readWithoutEncryption(parameters: [FeliCaReadWithoutEncryptionCommandParameter], didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        self.beginScanning(pollingOption: .iso18092, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didConnect tag: NFCTag) {
        print(self, #function, #line, session.connectedTag)
        
        guard case .feliCa(let feliCaTag) = session.connectedTag else {
            session.invalidate(errorMessage: "FeliCa タグではないものが検出されました。")
            DispatchQueue.main.async {
                self.resultHandler?(.failure(NSError()))
            }
            return
        }
        
        print("FeliCa タグでした🎉", feliCaTag.currentSystemCode as NSData)
        session.alertMessage = "完了"
        session.invalidate()
        DispatchQueue.main.async {
            self.resultHandler?(.success(Data()))
        }
    }
}

#endif
