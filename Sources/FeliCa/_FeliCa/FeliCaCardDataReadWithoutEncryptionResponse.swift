//
//  FeliCaCardDataReadWithoutEncryptionResponse.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

public struct FeliCaCardDataReadWithoutEncryptionResponse: FeliCaReadWithoutEncryptionResponse {
    public let feliCaData: FeliCaData
    public let pollingErrors: [FeliCaSystemCode : Error?]
    public let readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]
    
    public init(feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?], readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]) {
        self.feliCaData = feliCaData
        self.pollingErrors = pollingErrors
        self.readErrors = readErrors
    }
}
