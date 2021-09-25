//
//  NDEFTag+QueryingNDEFStatus.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/09/26.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension NDEFTag {
    /// Asks the reader session for the NDEF support status of the tag.
    /// - Parameters:
    ///   - resultHandler: Returns `(NDEFStatus, Int)` or an `NSError` object if the query fails. `status` is the `NDEFStatus` of the tag. `capacity` indicates the maximum NDEF message size, in bytes, that you can store on the tag.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func queryNDEFStatus(resultHandler: @escaping (Result<(NDEFStatus, Int), Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        self.core.queryNDEFStatus { status, capacity, error in
            if let error = error {
                resultHandler(.failure(error))
            } else {
                guard let status = NDEFStatus(rawValue: status.rawValue) else {
                    resultHandler(.failure(NDEFStatus.CaseError.unknown))
                    return
                }
                resultHandler(.success((status, capacity)))
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Not implemented. Use the one using resultHander.")
    public func queryNDEFStatus(completionHandler: @escaping (NFCNDEFStatus, Int, Error?) -> Void) {
        fatalError("\(#function): Not implemented. Use the one using resultHander.")
    }
}
