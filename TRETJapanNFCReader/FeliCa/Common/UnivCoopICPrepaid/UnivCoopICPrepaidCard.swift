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

/// 大学生協ICプリペイドカード
@available(iOS 13.0, *)
public struct UnivCoopICPrepaidCard: FeliCaCard {
    public let tag: UnivCoopICPrepaidCardTag
    public var data: UnivCoopICPrepaidCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = UnivCoopICPrepaidCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: UnivCoopICPrepaidCardTag, data: UnivCoopICPrepaidCardData) {
        self.tag = tag
        self.data = data
    }
}

public struct UnivCoopICPrepaidCardData: FeliCaCardData {
    public var type: FeliCaCardType = .univCoopICPrepaid
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
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
