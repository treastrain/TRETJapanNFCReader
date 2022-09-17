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
    public var version: String = "3"
    public let type: FeliCaCardType
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:]
    
    public init(type: FeliCaCardType = .unknown, idm: String, systemCode: FeliCaSystemCode) {
        self.type = type
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
    }
    
    public func convert() {
        
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}
