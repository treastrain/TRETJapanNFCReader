//
//  NFCReaderSession.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// The abstract base class that represents a reader session for detecting NFC tags.
open class NFCReaderSession: NFCReaderSessionProtocol {
    
    /// A Boolean value that determines whether the device supports NFC tag reading.
    open class var readingAvailable: Bool {
        return false
    }
    
    /// The delegate of the reader session.
    weak open var delegate: AnyObject?
    
    /// The queue on which the reader session delegate callbacks and completion block handlers are dispatched.
    open var sessionQueue: DispatchQueue = .main
    
    public var isReady = false
    
    public var alertMessage: String = ""
    
    public func begin() {
        
    }
    
    public func invalidate(errorMessage: String?) {
        
    }
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 11.0, *)
public extension CoreNFC.NFCReaderSession {
}
#endif
