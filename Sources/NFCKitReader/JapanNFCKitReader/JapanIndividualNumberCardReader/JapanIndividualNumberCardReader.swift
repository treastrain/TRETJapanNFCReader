//
//  JapanIndividualNumberCardReader.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

#if os(iOS)
import NFCKitReaderCore

/// A reader for detecting Japan Individual Number Card (個人番号カード、マイナンバーカード).
@available(iOS 13.0, *)
open class JapanIndividualNumberCardReader: NSObject {
    
    private var configuration: NFCKitReaderConfiguration
    private var delegate: JapanIndividualNumberCardReaderDelegate? = nil
    private var sessionQueue: DispatchQueue? = nil
    
    private var session: NFCTagReaderSession? = nil
    private var items: [JapanIndividualNumberCardItem] = []
    private var didBecomeActive: ((JapanIndividualNumberCardReader) -> Void)? = nil
    private var didInvalidateWithError: ((JapanIndividualNumberCardReader, Error) -> Void)? = nil
    
    private override init() {
        fatalError("init() has not been implemented")
    }
    
    /// Creates the Japan Individual Number Card (個人番号カード、マイナンバーカード) reader.
    /// - Parameters:
    ///   - configuration: A configuration object that specifies certain behaviors.
    ///   - delegate: An object that handles callbacks from the reader.
    ///   - queue: A dispatch queue that the reader uses when making callbacks to the delegate. When queue is nil, the reader creates and uses a serial dispatch queue.
    public init(configuration: NFCKitReaderConfiguration, delegate: JapanIndividualNumberCardReaderDelegate?, queue: DispatchQueue? = nil) {
        self.configuration = configuration
        self.delegate = delegate
        self.sessionQueue = queue
    }
    
    #if DEBUG
    deinit {
        print(self, "deinited 🎉")
    }
    #endif
    
    open func read(
        items: JapanIndividualNumberCardItem...,
        didBecomeActive: ((JapanIndividualNumberCardReader) -> Void)? = nil,
        didInvalidateWithError: ((JapanIndividualNumberCardReader, Error) -> Void)? = nil
    ) {
        read(items: items, didBecomeActive: didBecomeActive, didInvalidateWithError: didInvalidateWithError)
    }
    
    open func read(
        items: [JapanIndividualNumberCardItem],
        didBecomeActive: ((JapanIndividualNumberCardReader) -> Void)? = nil,
        didInvalidateWithError: ((JapanIndividualNumberCardReader, Error) -> Void)? = nil
    ) {
        guard NFCTagReaderSession.readingAvailable else {
            #if DEBUG
            print("""
            -------------------------------------------------------------------------
            ⚠️ Tips for developers from TRETNFCKit (Only visible in DEBUG builds) ⚠️
            Could not start scanning for NFC, please check if your device supports "NFC with reader mode". If your device supports "NFC with reader mode", but you still get this message, please check the following:
            \t• This message may appear when you have been using NFC in another application, or just finished using it.
            \t• Select the iOS Application you are developing from the project's TARGET and enable "Near Field Communication Tag Reading" in "Signing & Capabilities" ("Near Field Communication Tag Reader Session Formats (com.apple.developer.nfc.readersession.formats)" must be included in the entitlements file).
            \t\t‣ Make sure that the "Near Field Communication Tag Reader Session Formats (com.apple.developer.nfc.readersession.formats)" include "NFC tag-specific data protocol (TAG)".
            \t• Add "Privacy - NFC Scan Usage Description (NFCReaderUsageDescription)" to the Info.plist of the iOS Application you are developing. If you do not add this, you will get a "signal SIGABRT" error at runtime.
            If the above steps do not improve the situation, you should also suspect a malfunction of the device's NFC module.
            -------------------------------------------------------------------------
            """)
            #endif
            let error = NFCKitReaderError.readingUnavailable
            if let completion = didInvalidateWithError {
                completion(self, error)
            } else {
                delegate?.japanIndividualNumberCardReader(self, didInvalidateWithError: error)
            }
            return
        }
        
        #if DEBUG
        do {
            let result = InfoPlistChecker.check(forISO7816ApplicationIdentifiers: NFCKitISO7816ApplicationIdentifiers.japanIndividualNumberCard)
            if case .failure(let error) = result {
                assertionFailure(error.localizedDescription)
            }
        }
        #endif
        
        guard let session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self, queue: sessionQueue) else {
            let error = NFCKitReaderError.systemMemoryResourcesAreUnavailable
            if let completion = didInvalidateWithError {
                completion(self, error)
            } else {
                delegate?.japanIndividualNumberCardReader(self, didInvalidateWithError: error)
            }
            return
        }
        self.session = session
        self.items = items
        self.didBecomeActive = didBecomeActive
        self.didInvalidateWithError = didInvalidateWithError
        self.session?.alertMessage = configuration.didBeginReaderAlertMessage
        self.session?.begin()
    }
}

@available(iOS 13.0, *)
extension JapanIndividualNumberCardReader: NFCTagReaderSessionDelegate {
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        if let closure = didBecomeActive {
            closure(self)
        } else {
            delegate?.japanIndividualNumberCardReaderDidBecomeActive(self)
        }
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let closure = didInvalidateWithError {
            closure(self, error)
        } else {
            delegate?.japanIndividualNumberCardReader(self, didInvalidateWithError: error)
        }
    }
    
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard tags.count == 1 else {
            session.alertMessage = configuration.didDetectMoreThanOneTagAlertMessage
            DispatchQueue.global().asyncAfter(deadline: .now() + configuration.didDetectMoreThanOneTagRetryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        guard let tag = tags.first, case NFCTag.iso7816(let japanIndividualNumberCardTag) = tag else {
            session.alertMessage = configuration.didDetectDifferentTagTypeAlertMessage
            DispatchQueue.global().asyncAfter(deadline: .now() + configuration.didDetectDifferentTagTypeRetryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        session.connect(to: tag) { [weak self] error in
            if let error = error {
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard NFCKitISO7816ApplicationIdentifiers.japanIndividualNumberCard.contains(japanIndividualNumberCardTag.initialSelectedAID) else {
                let configuration = self?.configuration ?? .default
                session.alertMessage = configuration.didDetectDifferentTagTypeAlertMessage
                DispatchQueue.global().asyncAfter(deadline: .now() + configuration.didDetectDifferentTagTypeRetryInterval, execute: {
                    session.restartPolling()
                })
                return
            }
            
            for item in self?.items ?? [] {
                switch item {
                case .digitalSignature:
                    break
                case .userAuthentication:
                    break
                case .cardInfoInputSupportApplication:
                    break
                case .individualNumberCard:
                    break
                }
            }
            
            session.invalidate(doneMessage: (self?.configuration ?? .default).doneAlertMessage)
        }
    }
}
#endif
