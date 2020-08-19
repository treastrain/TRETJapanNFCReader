//
//  FeliCaPollingResponse.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/22.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
public struct FeliCaPollingResponse {
    /// PMm
    public var manufactureParameter: Data
    /// Data requested by the Request Code
    public var requestData: Data?
    
    init(_ manufactureParameter: Data, _ requestData: Data?) {
        self.manufactureParameter = manufactureParameter
        self.requestData = requestData
    }
    
    @available(iOS 14.0, *)
    init(_ pollingResponse: CoreNFC.NFCFeliCaPollingResponse) {
        self.manufactureParameter = pollingResponse.manufactureParameter
        self.requestData = pollingResponse.requestData
    }
}

#endif
