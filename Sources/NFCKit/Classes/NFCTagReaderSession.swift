//
//  NFCTagReaderSession.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// A reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE tags.
open class NFCTagReaderSession: NSObject, NFCReaderSessionProtocol {
    
    /// A Boolean value that determines whether the device supports NFC tag reading.
    ///
    /// Before creating a reader session, always check the `readingAvailable` property to determine whether the user’s device supports scanning for and detecting NFC tags.
    open class var readingAvailable: Bool {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 13.0, *) else {
            return false
        }
        
        return CoreNFC.NFCTagReaderSession.readingAvailable
        #else
        return false
        #endif
    }
    
    /// The delegate of the reader session.
    weak open var delegate: NFCTagReaderSessionDelegate?
    
    /// The queue on which the reader session delegate callbacks and completion block handlers are dispatched.
    open var sessionQueue: DispatchQueue = .main
    
    /// A Boolean value that indicates whether the reader session is started and ready to use.
    public var isReady: Bool {
        if #available(iOS 13.0, *) {
            return self.core.isReady
        } else {
            return false
        }
    }
    
    /// A custom description that helps users understand how they can use NFC reader mode in your app.
    public var alertMessage: String = ""
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    private var _core: Any?
    @available(iOS 13.0, *)
    private var core: CoreNFC.NFCTagReaderSession {
        get {
            return _core as! CoreNFC.NFCTagReaderSession
        }
        set {
            _core = newValue
        }
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    /// Creates an NFC tag reader session.
    /// - Parameters:
    ///   - pollingOption: One or more options specifying the type of tags that the reader session scans for and detects.
    ///   - delegate: An object that handles callbacks from the reader session.
    ///   - queue: A dispatch queue that the reader session uses when making callbacks to the delegate. When queue is nil, the session creates and uses a serial dispatch queue.
    @available(iOS 13.0, *)
    init?(pollingOption: NFCTagReaderSession.PollingOption, delegate: NFCTagReaderSessionDelegate, queue: DispatchQueue? = nil) {
        super.init()
        
        guard let core = CoreNFC.NFCTagReaderSession(pollingOption: .init(from: pollingOption), delegate: self, queue: queue) else {
            return nil
        }
        self.core = core
        self.delegate = delegate
        self.sessionQueue = queue ?? .main
    }
    #endif
    
    /// Starts the reader session.
    public func begin() {
        guard #available(iOS 13.0, *) else {
            print(#file, #line, #function, "This method is not supported in this environment, so it did nothing.")
            return
        }
        
        self.core.begin()
    }
    
    /// Closes the reader session and displays an error message to the user.
    public func invalidate(errorMessage: String? = nil) {
        guard #available(iOS 13.0, *) else {
            print(#file, #line, #function, "This method is not supported in this environment, so it did nothing.")
            return
        }
        
        if let errorMessage = errorMessage {
            self.core.invalidate(errorMessage: errorMessage)
        } else {
            self.core.invalidate()
        }
    }
}

@available(iOS 13.0, *)
extension NFCTagReaderSession: CoreNFC.NFCTagReaderSessionDelegate {
    public func tagReaderSessionDidBecomeActive(_ session: CoreNFC.NFCTagReaderSession) {
        self.delegate?.tagReaderSessionDidBecomeActive(self)
    }
    
    public func tagReaderSession(_ session: CoreNFC.NFCTagReaderSession, didInvalidateWithError error: Error) {
        self.delegate?.tagReaderSession(self, didInvalidateWithError: error)
    }
    
    public func tagReaderSession(_ session: CoreNFC.NFCTagReaderSession, didDetect tags: [NFCTag]) {
        self.delegate?.tagReaderSession(self, didDetect: tags)
    }
}
