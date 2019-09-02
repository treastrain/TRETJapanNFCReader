//
//  CommonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

#if os(iOS)
@available(iOS 13.0, *)
public struct FeliCaCommonCard: FeliCaCard {
    public let tag: NFCFeliCaTag
    public let data: FeliCaCommonCardData
    
    public init(tag: NFCFeliCaTag, data: FeliCaCommonCardData) {
        self.tag = tag
        self.data = data
    }
}
#endif

public struct FeliCaCommonCardData: FeliCaCardData {
    public let type: FeliCaCardType
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:]
    
    @available(iOS 13.0, *)
    public init(type: FeliCaCardType = .unknown, idm: String, systemCode: FeliCaSystemCode) {
        self.type = type
        self.idm = idm
        self.systemCode = systemCode
    }
    
    public func convert() {
        
    }
}
