//
//  NFCKitNDEFReaderSession.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/16.
//

import NFCKitCore

#if canImport(CoreNFC)
@available(iOS 13.0, *)
extension CoreNFC.NFCNDEFReaderSession {
    
    /// Connects the reader session to a tag and activates that tag.
    ///
    /// A tag stays connected until your app connects to a different tag or restarts polling. Connecting to a tag that is already connected has no effect.
    /// - Parameters:
    ///   - tag: A tag to which the reader session should attempt to connect.
    ///   - resultHandler: A handler that the reader session invokes after the operation completes. The handler receives a Result with the cases:
    ///   - success: A `Void`.
    ///   - failure: An `NFCReaderError` object indicating that a communication issue with the tag occurred.
    @available(iOS 13.0, *)
    open func connect(to tag: NFCNDEFTag, resultHandler: @escaping ((Result<Void, NFCReaderError>)) -> Void) {
        connect(to: tag, completionHandler: { error in
            if let error = error {
                resultHandler(.failure(error as! NFCReaderError))
            } else {
                resultHandler(.success(()))
            }
        })
    }
    
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    /// Connects the reader session to a tag and activates that tag.
    ///
    /// A tag stays connected until your app connects to a different tag or restarts polling. Connecting to a tag that is already connected has no effect.
    /// - Parameter tag: A tag to which the reader session should attempt to connect.
    /// - Returns: A Result with the cases:
    ///              success: A `Void`.
    ///              failure: An `NFCReaderError` object indicating that a communication issue with the tag occurred.
    open func connect(to tag: NFCNDEFTag) async -> Result<Void, NFCReaderError> {
        do {
            let _: Void = try await connect(to: tag)
            return .success(())
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    #elseif compiler(>=5.5) && canImport(_Concurrency)
    /// Connects the reader session to a tag and activates that tag.
    ///
    /// A tag stays connected until your app connects to a different tag or restarts polling. Connecting to a tag that is already connected has no effect.
    /// - Parameter tag: A tag to which the reader session should attempt to connect.
    /// - Returns: A Result with the cases:
    ///              success: A `Void`.
    ///              failure: An `NFCReaderError` object indicating that a communication issue with the tag occurred.
    @available(iOS 15.0, *)
    open func connect(to tag: NFCNDEFTag) async -> Result<Void, NFCReaderError> {
        do {
            let _: Void = try await connect(to: tag)
            return .success(())
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    #endif
}
#endif
