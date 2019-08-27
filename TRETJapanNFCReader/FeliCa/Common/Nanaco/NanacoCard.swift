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
    public var tag: NanacoCardTag
    public var type: FeliCaCardType = .nanaco
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    public var balance: Int?
    
    public init(from feliCaCard: FeliCaCard) {
        self.tag = feliCaCard.tag
        self.idm = feliCaCard.idm
        self.systemCode = feliCaCard.systemCode
    }
    
    public init(tag: NanacoCardTag, idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil) {
        self.tag = tag
        self.idm = idm
        self.systemCode = systemCode
        self.balance = balance
    }
    
}
