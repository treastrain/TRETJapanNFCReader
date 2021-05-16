//
//  FeliCaTag+RequestingServices.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Requesting Services
    
    /// Sends the Request Service command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - nodeCodeList: Node Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 32 inclusive. Each node code should be 2 bytes stored in Little Endian format.
    ///   - resultHandler: Completion handler called when the operation is completed. Node key version list is returned as an array of Data objects, and each data object is stored in Little Endian format per FeliCa specification.
    ///
    /// Request Service command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func requestService(nodeCodeList: [Data], resultHandler: @escaping (Result<[Data], Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.requestService(nodeCodeList: nodeCodeList, resultHandler: resultHandler)
        } else {
            self.core.requestService(nodeCodeList: nodeCodeList) { nodeKeyVersionList, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(nodeKeyVersionList))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestService(nodeCodeList: [Data], completionHandler: @escaping ([Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    /// Sends the Request Service V2 command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - nodeCodeList: Node Code list represent in an array of Data. Number of nodes specified should be between 1 to 32 inclusive. Each node code should be 2 bytes stored in Little Endian format.
    ///   - resultHandler: Completion handler called when the operation is completed. `encryptionIdentifier` value shall be ignored if Status Flag 1 value indicates an error. `nodeKeyVerionListAES` and `nodeKeyVersionListDES` may be nil depending on the Status Flag 1 value and the Encryption Identifier value. The 2 bytes node key version (AES and DES) is in Little Endian format.
    ///
    /// Request Service V2 command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func requestServiceV2(nodeCodeList: [Data], resultHandler: @escaping (Result<FeliCaRequsetServiceV2Response, Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.requestServiceV2(nodeCodeList: nodeCodeList) { result in
                switch result {
                case .success(let feliCaRequsetServiceV2Response):
                    resultHandler(.success(FeliCaRequsetServiceV2Response(from: feliCaRequsetServiceV2Response)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.requestServiceV2(nodeCodeList: nodeCodeList) { statusFlag1, statusFlag2, encryptionIdentifier, nodeKeyVersionListAES, nodeKeyVersionListDES, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(FeliCaRequsetServiceV2Response(statusFlag1: statusFlag1, statusFlag2: statusFlag2, encryptionIdentifier: encryptionIdentifier.rawValue, nodeKeyVersionListAES: nodeKeyVersionListAES, nodeKeyVersionListDES: nodeKeyVersionListDES)))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestServiceV2(nodeCodeList: [Data], completionHandler: @escaping (Int, Int, FeliCaEncryptionId, [Data], [Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
