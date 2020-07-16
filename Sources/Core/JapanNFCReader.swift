//
//  JapanNFCReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

/// The abstract base class that represents a NFC reader.
@available(iOS 13.0, *)
open class JapanNFCReader: NSObject, NFCTagReaderSessionDelegate {
    
    public var delegate: JapanNFCReaderDelegate?
    public var session: NFCTagReaderSession?
    public var didBecomeActiveHandler: (() -> Void)?
    public var resultHandler: ((Result<Data, Error>) -> Void)?
    
    private let queue = DispatchQueue(label: "jp.tret.japannfcreader", attributes: .concurrent)
    
    deinit {
        print(self, "deinited 🎉")
    }
    
    open func beginScanning(pollingOption: NFCTagReaderSession.PollingOption, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        guard NFCReaderSession.readingAvailable,
              let session = NFCTagReaderSession(pollingOption: pollingOption, delegate: self, queue: self.queue) else {
            resultHandler(.failure(NSError()))
            return
        }
        
        self.session = session
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.resultHandler = resultHandler
        
        self.session?.alertMessage = "カードを平らな面に置き、カードの下半分を隠すように iPhone をその上に置いてください。"
        self.session?.begin()
    }
    
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print(self, #function, #line, session)
        DispatchQueue.main.async {
            self.didBecomeActiveHandler?()
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(self, #function, #line, session, error)
        DispatchQueue.main.async {
            self.resultHandler?(.failure(error))
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print(self, #function, #line, session, tags)
        
        guard let tag = tags.first, tags.count == 1 else {
            session.invalidate(errorMessage: "タグが見つからなかったか、複数のタグが同時に検出されました。")
            DispatchQueue.main.async {
                self.resultHandler?(.failure(NSError()))
            }
            return
        }
        
        session.connect(to: tag) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.resultHandler?(.failure(error))
                }
            }
            
            self.delegate?.tagReaderSession(session, didConnect: tag)
        }
    }
}

#endif
