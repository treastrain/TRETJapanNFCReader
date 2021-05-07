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

open class NFCTagReaderSession: NFCReaderSessionProtocol {
    
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
    weak open var delegate: AnyObject?
    
    /// The queue on which the reader session delegate callbacks and completion block handlers are dispatched.
    open var sessionQueue: DispatchQueue = .main
    
    /// A Boolean value that indicates whether the reader session is started and ready to use.
    public var isReady = false
    
    /// A custom description that helps users understand how they can use NFC reader mode in your app.
    public var alertMessage: String = ""
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
//    @available(iOS 13.0, *)
//    convenience init?(pollingOption: NFCTagReaderSession.PollingOption, delegate: NFCTagReaderSessionDelegate, queue: DispatchQueue? = nil) {
//
//    }
    #endif
    
    /// Starts the reader session.
    public func begin() {
    }
    
    /// Closes the reader session and displays an error message to the user.
    public func invalidate(errorMessage: String?) {
    }
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 13.0, *)
public extension CoreNFC.NFCTagReaderSession {
}
#endif
