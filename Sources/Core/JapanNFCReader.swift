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
    
    /// A configuration object. See JapanNFCReader.Configuration for more information.
    public private(set) var configuration: Configuration = .default
    /// A dispatch queue that the reader uses when making callbacks to the closure.
    public private(set) var readerQueue: DispatchQueue = .main
    /// A reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE tags.
    public private(set) var session: NFCTagReaderSession?
    /// A handler called when the reader is active.
    public private(set) var didBecomeActiveHandler: (() -> Void)?
    /// A completion handler called when the operation is completed.
    public private(set) var resultHandler: ((Result<(NFCTagReaderSession, NFCTag), Error>) -> Void)?
    
    private let sessionQueue = DispatchQueue(label: "jp.tret.japannfcreader", attributes: .concurrent)
    
    private override init() {
        super.init()
    }
    
    public init(configuration: Configuration = .default) {
        self.configuration = configuration
    }
    
    deinit {
        print(self, "deinited 🎉")
    }
    
    /// Starts the reader session.
    /// - Parameters:
    ///   - pollingOption: One or more options specifying the type of tags that the reader session scans for and detects.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    open func beginScanning(pollingOption: NFCTagReaderSession.PollingOption, queue readerQueue: DispatchQueue = .main, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: @escaping (Result<(NFCTagReaderSession, NFCTag), Error>) -> Void) {
        self.readerQueue = readerQueue
        
        guard NFCTagReaderSession.readingAvailable else {
            resultHandler(.failure(JapanNFCReaderError.readingUnavailable))
            return
        }
        guard let session = NFCTagReaderSession(pollingOption: pollingOption, delegate: self, queue: self.sessionQueue) else {
            resultHandler(.failure(JapanNFCReaderError.couldNotCreateTagReaderSession))
            return
        }
        
        self.session = session
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.resultHandler = resultHandler
        
        self.session?.alertMessage = "カードを平らな面に置き、カードの下半分を隠すように iPhone をその上に置いてください。"
        self.session?.begin()
    }
    
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // print(self, #function, #line, session)
        session.isSuccessfullyFinished = false
        self.readerQueue.async {
            self.didBecomeActiveHandler?()
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // print(self, #function, #line, session, error)
        self.readerQueue.async {
            if !self.configuration.returnsReaderSessionInvalidationErrorUserCanceledAfterNFCConnectionCompleted,
               session.isSuccessfullyFinished,
               (error as? NFCReaderError)?.code == .readerSessionInvalidationErrorUserCanceled {
                return
            }
            
            self.resultHandler?(.failure(JapanNFCReaderError.tagReaderSessionDidInvalidateWithError(error)))
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // print(self, #function, #line, session, tags)
        
        guard tags.count == 1 else {
            session.alertMessage = "More than 1 tags found. Please present only 1 tag."
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                session.restartPolling()
            })
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { (error) in
            if let error = error {
                self.readerQueue.async {
                    self.resultHandler?(.failure(JapanNFCReaderError.tagReaderSessionConnectError(error)))
                }
            } else {
                self.resultHandler?(.success((session, tag)))
            }
        }
    }
}

#endif
