//
//  FeliCaTag+ReadingAndWritingWithoutEncryption.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Reading and Writing Without Encryption
    
    /// Sends the Read Without Encryption command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - serviceCodeList: Service Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 16 inclusive. Each service code should be 2 bytes stored in Little Endian format.
    ///   - blockList: Block List represent in an array of Data objects. 2-Byte or 3-Byte block list element is supported.
    ///   - resultHandler: Completion handler called when the operation is completed. Valid read data blocks (block length of 16 bytes) are returned in an array of Data objects when Status Flag 1 equals zero.
    ///
    /// Read Without Encrypton command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func readWithoutEncryption(serviceCodeList: [Data], blockList: [Data], resultHandler: @escaping (Result<(FeliCaStatusFlag, [Data]), Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { result in
                switch result {
                case .success((let feliCaStatusFlag, let blocks)):
                    resultHandler(.success((FeliCaStatusFlag(from: feliCaStatusFlag), blocks)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { statusFlag1, statusFlag2, blocks, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success((FeliCaStatusFlag(statusFlag1: statusFlag1, statusFlag2: statusFlag2), blocks)))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func readWithoutEncryption(serviceCodeList: [Data], blockList: [Data], completionHandler: @escaping (Int, Int, [Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    /// Sends the Write Without Encryption command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - serviceCodeList: Service Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 16 inclusive. Each service code should be 2 bytes stored in Little Endian format.
    ///   - blockList: Block List represent in an array of Data objects. Total blockList items and blockData items should match. 2-Byte or 3-Byte block list element is supported.
    ///   - blockData: Block data represent in an array of Data objects. Total blockList items and blockData items should match. Data block should be 16 bytes in length.
    ///   - resultHandler: Returns `NFCFeliCaStatusFlag` or a `NFCErrorDomain` error when operation is completed.
    ///
    /// Write Without Encrypton command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func writeWithoutEncryption(serviceCodeList: [Data], blockList: [Data], blockData: [Data], resultHandler: @escaping (Result<FeliCaStatusFlag, Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 14.0, *) {
            self.core.writeWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList, blockData: blockData) { result in
                switch result {
                case .success(let feliCaStatusFlag):
                    resultHandler(.success(FeliCaStatusFlag(from: feliCaStatusFlag)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.writeWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList, blockData: blockData) { statusFlag1, statusFlag2, error in
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
    public func writeWithoutEncryption(serviceCodeList: [Data], blockList: [Data], blockData: [Data], completionHandler: @escaping (Int, Int, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
