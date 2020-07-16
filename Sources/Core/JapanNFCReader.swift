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
    
    /// An object that handles callbacks from the reader.
    public private(set) weak var readerDelegate: JapanNFCReaderDelegate?
    /// A dispatch queue that the reader uses when making callbacks to the delegate or closure.
    public private(set) var readerQueue: DispatchQueue = .main
    /// A reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE tags.
    public private(set) var session: NFCTagReaderSession?
    /// A handler called when the reader is active.
    public private(set) var didBecomeActiveHandler: (() -> Void)?
    /// A completion handler called when the operation is completed.
    public private(set) var resultHandler: ((Result<Data, Error>) -> Void)?
    
    private let sessionQueue = DispatchQueue(label: "jp.tret.japannfcreader", attributes: .concurrent)
    
    deinit {
        print(self, "deinited 🎉")
    }
    
    /// Starts the reader session.
    /// - Parameters:
    ///   - pollingOption: One or more options specifying the type of tags that the reader session scans for and detects.
    ///   - readerDelegate: An object that handles callbacks from the reader. This is NOT the delgate specified for `NFCTagReaderSession` init.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    open func beginScanning(pollingOption: NFCTagReaderSession.PollingOption, delegate readerDelegate: JapanNFCReaderDelegate, queue readerQueue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        self.readerDelegate = readerDelegate
        self.readerQueue = readerQueue
        
        guard NFCReaderSession.readingAvailable,
              let session = NFCTagReaderSession(pollingOption: pollingOption, delegate: self, queue: self.sessionQueue) else {
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
        self.readerQueue.async {
            self.didBecomeActiveHandler?()
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print(self, #function, #line, session, error)
        self.readerQueue.async {
            self.resultHandler?(.failure(error))
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print(self, #function, #line, session, tags)
        
        guard let tag = tags.first, tags.count == 1 else {
            session.invalidate(errorMessage: "タグが見つからなかったか、複数のタグが同時に検出されました。")
            self.readerQueue.async {
                self.resultHandler?(.failure(NSError()))
            }
            return
        }
        
        session.connect(to: tag) { (error) in
            if let error = error {
                self.readerQueue.async {
                    self.resultHandler?(.failure(error))
                }
            }
            
            self.readerDelegate?.tagReaderSession(session, didConnect: tag)
        }
    }
}

#endif
