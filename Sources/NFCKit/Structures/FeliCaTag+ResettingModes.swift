//
//  FeliCaTag+ResettingModes.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Resetting Modes
    
    /// Sends the Reset Mode command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns `NFCFeliCaStatusFlag` or a `NFCErrorDomain` error when the operation is completed.
    ///
    /// Reset Mode command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func resetMode(resultHandler: @escaping (Result<FeliCaStatusFlag, Error>) -> Void) {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.resetMode { result in
                switch result {
                case .success(let feliCaStatusFlag):
                    resultHandler(.success(FeliCaStatusFlag(from: feliCaStatusFlag)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.resetMode { statusFlag1, statusFlag2, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(FeliCaStatusFlag(statusFlag1: statusFlag1, statusFlag2: statusFlag2)))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func resetMode(completionHandler: @escaping (Int, Int, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
