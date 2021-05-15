//
//  FeliCaTag+Polling.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Polling
    
    /// Sends the Polling command as defined by FeliCa card specification to the tag.
    /// - Parameters:
    ///   - systemCode: Designation of System Code. Wildcard value (`0xFF`) in the upper or the lower byte is not supported.
    ///   - requestCode: Designation of Requset Data output.
    ///   - timeSlot: Maximum number of slots possible to respond.
    ///   - resultHandler: Returns `FeliCaPollingResponse` or a `NFCErrorDomain` error when the operation is completed. Valid `requestData` is return when `requestCode` is a non-zero parameter and feature is supported by the tag. The `currentIDm` property will be updated on each execution, except when an invalid `systemCode` is provided and the existing selected system will stay selected.
    ///
    /// System code must be one of the provided values in the "com.apple.developer.nfc.readersession.felica.systemcodes" in the Info.plist; `NFCReaderErrorSecurityViolation` will be returned when an invalid system code is used. Polling with wildcard value in the upper or lower byte is not supported.
    @available(iOS 13.0, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @available(macOS, unavailable)
    @available(macCatalyst, unavailable)
    public func polling(systemCode: Data, requestCode: FeliCaPollingRequestCode, timeSlot: FeliCaPollingTimeSlot, resultHandler: @escaping (Result<FeliCaPollingResponse, Error>) -> Void) {
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        let coreRequestCode: PollingRequestCode
        switch requestCode {
        case .noRequest:
            coreRequestCode = .noRequest
        case .systemCode:
            coreRequestCode = .systemCode
        case .communicationPerformance:
            coreRequestCode = .communicationPerformance
        }
        
        let coreTimeSlot: PollingTimeSlot
        switch timeSlot {
        case .max1:
            coreTimeSlot = .max1
        case .max2:
            coreTimeSlot = .max2
        case .max4:
            coreTimeSlot = .max4
        case .max8:
            coreTimeSlot = .max8
        case .max16:
            coreTimeSlot = .max16
        }
        
        if #available(iOS 14.0, *) {
            self.core.polling(systemCode: systemCode, requestCode: coreRequestCode, timeSlot: coreTimeSlot) { result in
                switch result {
                case .success(let feliCaPollingResponse):
                    resultHandler(.success(FeliCaPollingResponse(from: feliCaPollingResponse)))
                case .failure(let error):
                    resultHandler(.failure(error))
                }
            }
        } else {
            self.core.polling(systemCode: systemCode, requestCode: coreRequestCode, timeSlot: coreTimeSlot) { manufactureParameter, requestData, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(FeliCaPollingResponse(manufactureParameter: manufactureParameter, requestData: requestData)))
                }
            }
        }
        #else
        fatalError("\(#function): Not implemented")
        #endif
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func polling(systemCode: Data, requestCode: FeliCaPollingRequestCode, timeSlot: FeliCaPollingTimeSlot, completionHandler: @escaping (Data, Data, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
