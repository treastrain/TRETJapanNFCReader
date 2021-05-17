//
//  NDEFTagProtocol.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation

public protocol NDEFTagProtocol {
    /// A Boolean value that determines whether the NDEF tag is available in the current reader session.
    var isAvailable: Bool { get }
    
    /// Asks the reader session for the NDEF support status of the tag.
    /// - Parameters:
    ///   - resultHandler: Returns `(NDEFStatus, Int)` or an `NSError` object if the query fails. `status` is the `NDEFStatus` of the tag. `capacity` indicates the maximum NDEF message size, in bytes, that you can store on the tag.
    @available(iOS 13.0, watchOS 99.0, tvOS 99.0, macOS 99.0, macCatalyst 99.0, *)
    func queryNDEFStatus(resultHandler: @escaping (Result<(NDEFStatus, Int), Error>) -> Void)
    
    /// Retrieves an NDEF message from the tag.
    /// - Parameters:
    ///   - resultHandler: The handler invoked by the reader session that provides the NDEF message. The handler has the following parameters: `message` is an `NDEFMessage` object, or nil if an error occurs while retrieving the message. An `NSError` object if the query fails.
    @available(iOS 13.0, watchOS 99.0, tvOS 99.0, macOS 99.0, macCatalyst 99.0, *)
    func readNDEF(resultHandler: @escaping (Result<NDEFMessage?, Error>) -> Void)
    
    /// Saves an NDEF message to a writable tag.
    /// - Parameters:
    ///   - ndefMessage: The NDEF message to write to the tag.
    ///   - resultHandler: The handler invoked by the reader session after completing the write request. The session calls completionHandler on the dispatch queue provided when creating the `NDEFReaderSession`. An `NSError` object if the write request fails. A value of `Void` indicates that the write was successful.
    ///
    /// To determine whether the tag is writable, call `queryNDEFStatus(completionHandler:)` and check that the status is `NDEFStatus.readWrite`.
    @available(iOS 13.0, watchOS 99.0, tvOS 99.0, macOS 99.0, macCatalyst 99.0, *)
    func writeNDEF(_ ndefMessage: NDEFMessage, resultHandler: @escaping (Result<Void, Error>) -> Void)
    
    /// Changes the NDEF tag status to read-only, preventing future write operations.
    /// - Parameters:
    ///   - resultHandler: The handler invoked by the reader session after completing the lock request. The session calls completionHandler on the dispatch queue provided when creating the `NFCNDEFReaderSession`. An `NSError` object if the write request fails. A value of `Void` indicates that the session locked the tag and future write requests aren't possible.
    ///
    /// Calling this method updates the write access condition byte in the NDEF File Control of the tag's file system, thus locking the tag. This is a permanent action that you cannot undo. After locking the tag, you can no longer write data to it.
    @available(iOS 13.0, watchOS 99.0, tvOS 99.0, macOS 99.0, macCatalyst 99.0, *)
    func writeLock(resultHandler: @escaping (Result<Void, Error>) -> Void)
}
