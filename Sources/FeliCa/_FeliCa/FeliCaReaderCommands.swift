//
//  FeliCaReaderCommands.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
extension NFCFeliCaTag {
    
    /// Polling command defined by FeliCa card specification.  Refer to the FeliCa specification for details. System code must be one of the provided values in the "com.apple.developer.nfc.readersession.felica.systemcodes" in the Info.plist; `NFCReaderErrorSecurityViolation` will be returned when an invalid system code is used.  Polling with wildcard value in the upper or lower byte is not supported.
    /// - Parameters:
    ///   - systemCode: Designation of System Code.  Wildcard value (0xFF) in the upper or the lower byte is not supported.
    ///   - requestCode: Designation of Requset Data output.
    ///   - timeSlot: Maximum number of slots possible to respond.
    ///   - resultHandler: Returns `FeliCaPollingResponse` or a `NFCErrorDomain` error when the operation is completed.  Valid `requestData` is return when `requestCode` is a non-zero parameter and feature is supported by the tag. The `currentIDM` property will be updated on each execution, except when an invalid `systemCode` is provided and the existing selected system will stay selected.
    public func polling(systemCode: Data, requestCode: PollingRequestCode, timeSlot: PollingTimeSlot, resultHandler: @escaping (Result<FeliCaPollingResponse, Error>) -> Void) {
        if #available(iOS 14.0, *) {
            self.polling(systemCode: systemCode, requestCode: requestCode, timeSlot: timeSlot) { (response: Result<NFCFeliCaPollingResponse, Error>) in
                switch response {
                case .success(let pollingResponse):
                    resultHandler(.success(FeliCaPollingResponse(pollingResponse)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.polling(systemCode: systemCode, requestCode: requestCode, timeSlot: timeSlot) { (manufactureParameter, requestData, error) in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(FeliCaPollingResponse(manufactureParameter, requestData)))
                }
            }
        }
    }
    
    /// Polling command defined by FeliCa card specification. Refer to the FeliCa specification for details. System code must be one of the provided values in the "com.apple.developer.nfc.readersession.felica.systemcodes" in the Info.plist; `NFCReaderErrorSecurityViolation` will be returned when an invalid system code is used.  Polling with wildcard value in the upper or lower byte is not supported.
    /// - Parameters:
    ///   - systemCode: Designation of System Code.  Wildcard value (0xFF) in the upper or the lower byte is not supported.
    ///   - requestCode: Designation of Requset Data output.
    ///   - timeSlot: Maximum number of slots possible to respond.
    ///   - resultHandler: Returns `FeliCaPollingResponse` or a `NFCErrorDomain` error when the operation is completed.  Valid `requestData` is return when `requestCode` is a non-zero parameter and feature is supported by the tag. The `currentIDM` property will be updated on each execution, except when an invalid `systemCode` is provided and the existing selected system will stay selected.
    /// - Important: Response data is returned synchronously.
    public func polling(systemCode: Data, requestCode: PollingRequestCode, timeSlot: PollingTimeSlot) -> Result<FeliCaPollingResponse, Error> {
        var result: Result<FeliCaPollingResponse, Error>!
        let semaphore = DispatchSemaphore(value: 0)
        self.polling(systemCode: systemCode, requestCode: requestCode, timeSlot: timeSlot) { (response) in
            result = response
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    /// Read Without Encryption command defined by FeliCa card specification.  Refer to the FeliCa specification for details.
    /// - Parameters:
    ///   - serviceCodeList: Service Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 16 inclusive. Each service code should be 2 bytes stored in Little Endian format.
    ///   - blockList: Block List represent in an array of Data objects. 2-Byte or 3-Byte block list element is supported.
    ///   - resultHandler: Completion handler called when the operation is completed. Valid read data blocks (block length of 16 bytes) are returned in an array of Data objects when Status Flag 1 equals zero.
    public func readWithoutEncryption(serviceCodeList: [Data], blockList: [Data], resultHandler: @escaping (Result<(FeliCaStatusFlag, [Data]), Error>) -> Void) {
        if #available(iOS 14.0, *) {
            self.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (response: Result<(NFCFeliCaStatusFlag, [Data]), Error>) in
                switch response {
                case .success((let statusFlag, let blockData)):
                    resultHandler(.success((FeliCaStatusFlag(statusFlag), blockData)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (statusFlag1, statusFlag2, blockData, error) in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success((FeliCaStatusFlag(statusFlag1, statusFlag2), blockData)))
                }
            }
        }
    }
    
    /// Read Without Encryption command defined by FeliCa card specification, is sent to the tag separately for continued processing when the number of elements in the blockList is 13 to 36.
    /// - Parameters:
    ///   - serviceCode: Service Code
    ///   - blockList: Block List represent in an array of Data objects. 2-Byte or 3-Byte block list element is supported.
    ///   - resultHandler: Completion handler called when the operation is completed. Valid read data blocks (block length of 16 bytes) are returned in an array of Data objects when Status Flag 1 equals zero.
    public func readWithoutEncryption36(serviceCode: Data, blockList: [Data], resultHandler: @escaping (Result<(FeliCaStatusFlag, [Data]), Error>) -> Void) {
        
        var completionBlockData: [Data] = []
        
        let blockLists = blockList.split(count: 12)
        let blockList = blockLists.first ?? []
        
        self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList) { (response) in
            switch response {
            case .success((let statusFlag, let blockData)):
                guard statusFlag.isSucceeded, blockLists.count >= 2 else {
                    resultHandler(.success((statusFlag, blockData)))
                    return
                }
                
                completionBlockData += blockData
                self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockLists[1]) { (response) in
                    switch response {
                    case .success((let statusFlag, let blockData)):
                        completionBlockData += blockData
                        
                        guard statusFlag.isSucceeded, blockLists.count >= 3 else {
                            resultHandler(.success((statusFlag, completionBlockData)))
                            return
                        }
                        self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockLists[2]) { (response) in
                            switch response {
                            case .success((let statusFlag, let blockData)):
                                completionBlockData += blockData
                                resultHandler(.success((statusFlag, completionBlockData)))
                            case .failure(let error):
                                resultHandler(.failure(error))
                            }
                        }
                    case .failure(let error):
                        resultHandler(.failure(error))
                    }
                }
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
    /// Read Without Encryption command defined by FeliCa card specification, is sent to the tag separately for continued processing when the number of elements in the blockList is 13 to 36.
    /// - Parameters:
    ///   - serviceCode: Service Code
    ///   - blockList: Block List represent in an array of Data objects. 2-Byte or 3-Byte block list element is supported.
    /// - Important: Response data is returned synchronously.
    public func readWithoutEncryption36(serviceCode: Data, blockList: [Data]) -> Result<(FeliCaStatusFlag, [Data]), Error> {
        var result: Result<(FeliCaStatusFlag, [Data]), Error>!
        let semaphore = DispatchSemaphore(value: 0)
        self.readWithoutEncryption36(serviceCode: serviceCode, blockList: blockList) { (response) in
            result = response
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    /// Request System Code command defined by FeliCa card specification.  Refer to the FeliCa specification for details.
    /// - Returns: Returns an array of system code as Data or a `NFCErrorDomain` error when the operation is completed.  Each system code is 2 bytes stored in Little Endian format.
    /// - Important: Response data is returned synchronously.
    public func requestSystemCode() -> Result<[Data], Error> {
        var result: Result<[Data], Error>!
        let semaphore = DispatchSemaphore(value: 0)
        if #available(iOS 14.0, *) {
            self.requestSystemCode { (response) in
                result = response
                semaphore.signal()
            }
        } else {
            self.requestSystemCode { (systemCodes, error) in
                if let error = error {
                    result = .failure(error)
                } else {
                    result = .success(systemCodes)
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return result
    }
}

#endif
