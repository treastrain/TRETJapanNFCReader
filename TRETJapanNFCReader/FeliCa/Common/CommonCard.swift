//
//  CommonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
public struct FeliCaCommonCard: FeliCaCard {
    public var tag: NFCFeliCaTag
    public var type: FeliCaCardType
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    public init(tag: NFCFeliCaTag, type: FeliCaCardType = .unknown, idm: String, systemCode: FeliCaSystemCode) {
        self.tag = tag
        self.type = type
        self.idm = idm
        self.systemCode = systemCode
    }
}
