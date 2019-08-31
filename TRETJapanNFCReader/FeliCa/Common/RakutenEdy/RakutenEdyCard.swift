//
//  RakutenEdyCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 楽天Edyカードから読み取ることができるデータの種別
public enum RakutenEdyCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// Edy番号
    case edyNumber
    /// 利用履歴
    case transactions
    
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x1317
        case .edyNumber:
            return 0x110B
        case .transactions:
            return 0x170F
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .edyNumber:
            return 1
        case .transactions:
            return 6
        }
    }
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
    public var data: [FeliCaServiceCode : [Data]] = [:]
    
    public var balance: Int?
    public var edyNumber: String?
    public var transactions: [RakutenEdyCardTransaction]?
    
    @available(iOS 13.0, *)
    fileprivate init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
        self.data = feliCaCommonCardData.data
    }
}

public struct RakutenEdyCardTransaction: FeliCaCardTransaction {
    public var date: Date
    public var type: FeliCaCardTransactionType
    public var difference: Int
    public var balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.difference = difference
        self.balance = balance
    }
}
