//
//  FeliCaTag+RequestingSystemCodes.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Requesting System Codes
    
    /// Sends the Request System Code command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns an array of system code as Data or a `NFCErrorDomain` error when the operation is completed. Each system code is 2 bytes stored in Little Endian format.
    ///
    /// Request System Code command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func requestSystemCode(resultHandler: @escaping (Result<[Data], Error>) -> Void) {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.requestSystemCode(resultHandler: resultHandler)
        } else {
            self.core.requestSystemCode { systemCodeList, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(systemCodeList))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestSystemCode(completionHandler: @escaping ([Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
