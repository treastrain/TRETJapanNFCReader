//
//  NFCReaderSessionProtocol.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// A general interface for interacting with a reader session.
public protocol NFCReaderSessionProtocol {
    /// A Boolean value that indicates whether the reader session is started and ready to use.
    var isReady: Bool { get }
    
    /// A custom description that helps users understand how they can use NFC reader mode in your app.
    var alertMessage: String { get set }
    
    /// Starts the reader session.
    func begin()
    
    /// Closes the reader session and displays an error message to the user.
    /// - Parameter errorMessage: The error message to display.
    func invalidate(errorMessage: String?)
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 11.0, *)
public extension CoreNFC.NFCReaderSessionProtocol {
}
#endif
