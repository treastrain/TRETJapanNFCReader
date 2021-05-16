//
//  FeliCaTag+RequestingSpecificationVersions.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Requesting Specification Versions
    
    /// Sends the Request Specification Version command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns `NFCFeliCaRequestSpecificationVersionResponse` or a `NFCErrorDomain` error when the operation is completed.
    ///           `basicVersion` and `optionVersion` may be nil depending on the Status Flag 1 value and if the tag supports AES/DES.
    ///
    /// Request Specification Verison command defined by FeliCa card specification. This command supports response format version `00`h. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func requestSpecificationVersion(resultHandler: @escaping (Result<FeliCaRequestSpecificationVersionResponse, Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.requestSpecificationVersion { result in
                switch result {
                case .success(let feliCaRequestSpecificationVersionResponse):
                    resultHandler(.success(FeliCaRequestSpecificationVersionResponse(from: feliCaRequestSpecificationVersionResponse)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.requestSpecificationVersion { statusFlag1, statusFlag2, basicVersion, optionVersion, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(FeliCaRequestSpecificationVersionResponse(statusFlag1: statusFlag1, statusFlag2: statusFlag2, basicVersion: basicVersion, optionVersion: optionVersion)))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestSpecificationVersion(completionHandler: @escaping (Int, Int, Data, Data, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
