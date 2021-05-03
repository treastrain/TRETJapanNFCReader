//
//  FeliCaPollingResponse.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/02/19.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Response from Polling command.
public struct FeliCaPollingResponse: Codable {
    public init(manufactureParameter: Data, requestData: Data?) {
        self.manufactureParameter = manufactureParameter
        self.requestData = requestData
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCFeliCaPollingResponse) {
        self.manufactureParameter = coreNFCInstance.manufactureParameter
        self.requestData = coreNFCInstance.requestData
    }
    #endif
    
    /// PMm
    public var manufactureParameter: Data

    /// Data requested by the Request Code
    public var requestData: Data?
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCFeliCaPollingResponse {
    init(from nfcKitInstance: FeliCaPollingResponse) {
        self.init(manufactureParameter: nfcKitInstance.manufactureParameter, requestData: nfcKitInstance.requestData)
    }
}
#endif
