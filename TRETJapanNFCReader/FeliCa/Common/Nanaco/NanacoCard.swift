//
//  NanacoCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// nanacoカードから読み取ることができるデータの種別
public enum NanacoCardItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
}

/// nanacoカード
@available(iOS 13.0, *)
public struct NanacoCard: FeliCaCard {
    public let tag: NanacoCardTag
    public var data: NanacoCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = NanacoCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: NanacoCardTag, data: NanacoCardData) {
        self.tag = tag
        self.data = data
    }
    
}

public struct NanacoCardData: FeliCaCardData {
    public let type: FeliCaCardType = .nanaco
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
