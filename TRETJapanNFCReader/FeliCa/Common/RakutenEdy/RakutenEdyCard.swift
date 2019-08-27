//
//  RakutenEdyCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 楽天Edyカードから読み取ることができるデータの種別
public enum RakutenEdyCardItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
}

/// 楽天Edyカード
@available(iOS 13.0, *)
public struct RakutenEdyCard: FeliCaCard {
    public let tag: RakutenEdyCardTag
    public var data: RakutenEdyCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = RakutenEdyCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: RakutenEdyCardTag, data: RakutenEdyCardData) {
        self.tag = tag
        self.data = data
    }
}

public struct RakutenEdyCardData: FeliCaCardData {
    public let type: FeliCaCardType = .rakutenEdy
    public let idm: String
    public let systemCode: FeliCaSystemCode
    
    public var balance: Int?
    
    @available(iOS 13.0, *)
    fileprivate init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
    }
    
    @available(iOS 13.0, *)
    public init(idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil) {
        self.idm = idm
        self.systemCode = systemCode
        self.balance = balance
    }
}
