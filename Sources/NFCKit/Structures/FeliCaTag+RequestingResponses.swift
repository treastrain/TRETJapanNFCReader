//
//  FeliCaTag+RequestingResponses.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Requesting Responses
    
    /// Sends the Request Response command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns the mode as Int or a `NFCErrorDomain` error when the operation is completed. Valid mode value ranges from 0 to 3 inclusively.
    ///
    /// Request Response command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func requestResponse(resultHandler: @escaping (Result<Int, Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.requestResponse(resultHandler: resultHandler)
        } else {
            self.core.requestResponse { mode, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(mode))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestResponse(completionHandler: @escaping (Int, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
