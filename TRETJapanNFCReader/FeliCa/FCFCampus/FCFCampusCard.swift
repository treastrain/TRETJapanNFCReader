//
//  CommonCard.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

#if os(iOS)
@available(iOS 13.0, *)
public struct FCFCampusCard: FeliCaCard{
    public let tag: NFCFeliCaTag
    public let data: FCFCampusCardData
    
    public init(tag: NFCFeliCaTag, data: FCFCampusCardData) {
        self.tag = tag
        self.data = data
    }
}
#endif

public struct FCFCampusCardData: FeliCaCardData {
    public let type: FeliCaCardType
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:]
    
    @available(iOS 13.0, *)
    public init(type: FeliCaCardType = .fcfcampus, idm: String, systemCode: FeliCaSystemCode) {
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
