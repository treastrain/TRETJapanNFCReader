//
//  TransitICCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 交通系ICカードから読み取ることができるデータの種別
public enum TransitICCardItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
    /// 取引履歴
    case transactions
}

/// 交通系ICカード
@available(iOS 13.0, *)
public struct TransitICCard: FeliCaCard {
    public let tag: TransitICCardTag
    public var data: TransitICCardData
    
    public init(tag: TransitICCardTag, data: TransitICCardData) {
        self.tag = tag
        self.data = data
    }
}

public struct TransitICCardData: FeliCaCardData {
    public let type: FeliCaCardType = .transitIC
    public let idm: String
    public let systemCode: FeliCaSystemCode
    
    public var balance: Int?
    public var transactionsData: [Data]?
    
    @available(iOS 13.0, *)
    public init(idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil, transactionsData: [Data]? = nil) {
        self.idm = idm
        self.systemCode = systemCode
        self.balance = balance
        self.transactionsData = transactionsData
    }
}
