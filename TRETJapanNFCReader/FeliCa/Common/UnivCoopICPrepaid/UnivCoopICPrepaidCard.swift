//
//  UnivCoopICPrepaidCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 大学生協ICプリペイドカードから読み取ることができるデータの種別
public enum UnivCoopICPrepaidItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
}

@available(iOS 13.0, *)
public struct UnivCoopICPrepaidCard: FeliCaCard {
    public var tag: UnivCoopICPrepaidCardTag
    public var type: FeliCaCardType = .univCoopICPrepaid
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    public var balance: Int?
    
    public init(from feliCaCard: FeliCaCard) {
        self.tag = feliCaCard.tag
        self.idm = feliCaCard.idm
        self.systemCode = feliCaCard.systemCode
    }
    
    public init(tag: UnivCoopICPrepaidCardTag, idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil) {
        self.tag = tag
        self.idm = idm
        self.systemCode = systemCode
        self.balance = balance
    }
}
