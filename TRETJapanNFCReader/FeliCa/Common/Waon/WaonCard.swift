//
//  WaonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// WAONカードから読み取る事ができるデータの種別
public enum WaonCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// WAON番号
    case waonNumber
    /// ポイント
    case points
    /// 利用履歴
    case transactions
    
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x6817
        case .waonNumber:
            return 0x684F
        case .points:
            return 0x684B
        case .transactions:
            return 0x680B
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .waonNumber:
            return 1
        case .points:
            return 1
        case .transactions:
            return 9
        }
    }
}

/// WAONカード
@available(iOS 13.0, *)
public struct WaonCard: FeliCaCard {
    public let tag: WaonCardTag
    public var data: WaonCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = WaonCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: WaonCardTag, data: WaonCardData) {
        self.tag = tag
        self.data = data
    }
}

public struct WaonCardData: FeliCaCardData {
    public let type: FeliCaCardType = .waon
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:]
    
    public var balance: Int?
    public var waonNumber: String?
    public var points: Int?
    public var transactions: [WaonCardTransaction]?
    
    @available(iOS 13.0, *)
    fileprivate init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
    }
    
//    @available(iOS 13.0, *)
//    public init(idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil) {
//        self.idm = idm
//        self.systemCode = systemCode
//        self.balance = balance
//    }
}

public struct WaonCardTransaction: FeliCaCardTransaction {
    public let date: Date
    public let type: FeliCaCardTransactionType
    public let otherType: WaonCardTransactionType?
    public let difference: Int
    public let balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, otherType: WaonCardTransactionType? = nil, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.otherType = otherType
        self.difference = difference
        self.balance = balance
    }
}

public enum WaonCardTransactionType: String, Codable {
    /// 返品
    case returned
    /// ポイントダウンロード
    case pointDownload
    /// 返金
    case refunded
    /// オートチャージ
    case autoCredit
    /// 新カードへ移行
    case moveToNewCard
    /// ポイント交換
    case pointExchange
}
