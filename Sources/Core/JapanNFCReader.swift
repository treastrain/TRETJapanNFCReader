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
open class JapanNFCReader: NSObject {
    
    private let pollingOption: NFCTagReaderSession.PollingOption
    /// A configuration object. See JapanNFCReader.Configuration for more information.
    public private(set) var configuration: Configuration = .default
    /// The delegate of the reader.
    public private(set) weak var delegate: JapanNFCReaderDelegate? = nil
    /// The queue on which the reader delegate callbacks and completion block handlers are dispatched.
    public private(set) var readerQueue: DispatchQueue = .main
    /// A reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE tags.
    public private(set) var session: NFCTagReaderSession?
    /// A handler called when the reader is active.
    private var didBecomeActiveHandler: (() -> Void)? = nil
    /// A completion handler called when the operation is completed.
    private var resultHandler: ((Result<(NFCTagReaderSession, NFCTag), Error>) -> Void)? = nil
    
    private let sessionQueue = DispatchQueue(label: "jp.tret.japannfcreader", attributes: .concurrent)
    
    private override init() {
        self.pollingOption = []
        super.init()
    }
    
    /// Creates a reader with the specified session configuration, delegate, and reader queue.
    /// - Parameters:
    ///   - pollingOption: One or more options specifying the type of tags that the reader session scans for and detects.
    ///   - delegate: A reader delegate object that handles reader-related events. If nil, the class should be used only with methods that take result handlers.
    ///   - readerQueue: A dispatch queue that the reader uses when making callbacks to the delegate or closure. This is NOT the dispatch queue specified for `NFCTagReaderSession` init.
    ///   - configuration: A configuration object. See `JapanNFCReader.Configuration` for more information.
    public init(pollingOption: NFCTagReaderSession.PollingOption, delegate: JapanNFCReaderDelegate? = nil, queue readerQueue: DispatchQueue = .main, configuration: Configuration = .default) {
        self.pollingOption = pollingOption
        self.delegate = delegate
        self.readerQueue = readerQueue
        self.configuration = configuration
        super.init()
        if delegate == nil {
            self.delegate = self as? JapanNFCReaderDelegate
        }
    }
    
    deinit {
        print(self, "deinited 🎉")
    }
    
    /// Starts the reader session.
    open func beginScanning() {
        
        guard NFCTagReaderSession.readingAvailable else {
            self.delegate?.readerSessionDidInvalidate(with: .failure(JapanNFCReaderError.readingUnavailable))
            return
        }
        
        guard let session = NFCTagReaderSession(pollingOption: self.pollingOption, delegate: self, queue: self.sessionQueue) else {
            self.delegate?.readerSessionDidInvalidate(with: .failure(JapanNFCReaderError.couldNotCreateTagReaderSession))
            return
        }
        
        self.begin(session: session, didBecomeActive: nil, resultHandler: nil)
    }
    
    /// Starts the reader session, then calls a handler upon completion.
    /// - Parameters:
    ///   - didBecomeActiveHandler: A handler called when the reader is active.
    ///   - resultHandler: A completion handler called when the operation is completed.
    open func beginScanning(didBecomeActive didBecomeActiveHandler: @escaping (() -> Void), resultHandler: @escaping (Result<(NFCTagReaderSession, NFCTag), Error>) -> Void) {
        
        guard NFCTagReaderSession.readingAvailable else {
            resultHandler(.failure(JapanNFCReaderError.readingUnavailable))
            return
        }
        guard let session = NFCTagReaderSession(pollingOption: self.pollingOption, delegate: self, queue: self.sessionQueue) else {
            resultHandler(.failure(JapanNFCReaderError.couldNotCreateTagReaderSession))
            return
        }
        
        self.begin(session: session, didBecomeActive: didBecomeActiveHandler, resultHandler: resultHandler)
    }
    
    public func begin(session: NFCTagReaderSession, didBecomeActive didBecomeActiveHandler: (() -> Void)? = nil, resultHandler: ((Result<(NFCTagReaderSession, NFCTag), Error>) -> Void)? = nil) {
        self.session = session
        self.didBecomeActiveHandler = didBecomeActiveHandler
        self.resultHandler = resultHandler
        self.session?.alertMessage = Localize.String.beginAlertMessage
        self.session?.begin()
    }
    
    public func returnResultDelegateOrHandler(result: Result<(NFCTagReaderSession, NFCTag), Error>) {
        let work = {
            if let resultHandler = self.resultHandler {
                resultHandler(result)
            } else {
                self.delegate?.readerSessionDidInvalidate(with: result)
            }
        }
        
        switch result {
        case .success((_, _)):
            work()
        case .failure(_):
            self.readerQueue.async(execute: work)
        }
    }
}

@available(iOS 13.0, *)
extension JapanNFCReader: NFCTagReaderSessionDelegate {
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        session.isInvalidatedByUser = true
        self.readerQueue.async {
            if let didBecomeActiveHandler = self.didBecomeActiveHandler {
                didBecomeActiveHandler()
            } else {
                self.delegate?.readerSessionDidBecomeActive()
            }
        }
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if !self.configuration.returnsReaderSessionInvalidationErrorUserCanceledAfterNFCConnectionCompleted,
           !session.isInvalidatedByUser,
           (error as? NFCReaderError)?.code == .readerSessionInvalidationErrorUserCanceled {
            return
        }
        
        self.returnResultDelegateOrHandler(result: .failure(JapanNFCReaderError.tagReaderSessionDidInvalidateWithError(error)))
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // print("⏩", self, #function, #line, session, tags)
        
        guard tags.count == 1 else {
            session.alertMessage = Localize.String.tagReaderSessionMoreThanOneTagsFoundAlertMessage
            DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                session.restartPolling()
            })
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { (error) in
            if let error = error {
                self.returnResultDelegateOrHandler(result: .failure(JapanNFCReaderError.tagReaderSessionConnectError(error)))
            } else {
                self.returnResultDelegateOrHandler(result: .success((session, tag)))
            }
        }
    }
}

#endif
