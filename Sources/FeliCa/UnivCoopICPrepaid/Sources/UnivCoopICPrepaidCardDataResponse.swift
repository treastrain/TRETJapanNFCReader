//
//  UnivCoopICPrepaidCardDataResponse.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/16.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public struct UnivCoopICPrepaidCardDataResponse: FeliCaReadWithoutEncryptionResponse {
    public let cardData: UnivCoopICPrepaidCardData
    public let feliCaData: FeliCaData
    public let pollingErrors: [FeliCaSystemCode : Error?]
    public let readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]
}
