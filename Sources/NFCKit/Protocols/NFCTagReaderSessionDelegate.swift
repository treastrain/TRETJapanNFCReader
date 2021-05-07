//
//  NFCTagReaderSessionDelegate.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import Foundation

public protocol NFCTagReaderSessionDelegate: AnyObject {
    /// Tells the delegate that the reader session is active.
    ///
    /// The reader session calls this method after the device begins scanning for new tags.
    /// - Parameter session: The active reader session. Only one session can be active at a time.
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession)
    
    /// Tells the delegate that the session detected NFC tags.
    ///
    /// The polling options specified when creating an `NFCTagReaderSession` object determine the types of tags that the session can detect.
    /// - Parameters:
    ///   - session: The session that detected the tags.
    ///   - tags: An array of NFC tags detected by the session.
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [Any/*NFCTag*/])
    
    /// Tells the delegate the reason for invalidating a reader session.
    /// - Parameters:
    ///   - session: The session that has become invalid. Your app should discard any references it has to this session.
    ///   - error: The error indicating the reason for invalidation of the session.
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error)
}
