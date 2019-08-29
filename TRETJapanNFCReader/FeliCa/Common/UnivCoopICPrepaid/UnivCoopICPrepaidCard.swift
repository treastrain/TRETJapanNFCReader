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
    /// 大学生協
    case univCoopInfo
    /// 利用履歴
    case transactions
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
    public var membershipNumber: String?
    public var mealCardUser: Bool?
    public var mealCardLastUseDate: Date?
    public var mealCardLastUsageAmount: Int?
    public var points: Double?
    public var transactions: [UnivCoopICPrepaidCardTransaction]?
    
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

public struct UnivCoopICPrepaidCardTransaction: FeliCaCardTransaction {
    public let date: Date
    public let type: FeliCaCardTransactionType
    public let difference: Int
    public let balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.difference = difference
        self.balance = balance
    }
}
