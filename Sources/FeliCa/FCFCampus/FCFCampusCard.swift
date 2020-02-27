//
//  CommonCard.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public struct FCFCampusCard: FeliCaCard {
    public let tag: NFCFeliCaTag
    public let data: FCFCampusCardData
    
    public init(tag: NFCFeliCaTag, data: FCFCampusCardData) {
        self.tag = tag
        self.data = data
    }
}

public struct FCFCampusCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:]
    
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

#endif
