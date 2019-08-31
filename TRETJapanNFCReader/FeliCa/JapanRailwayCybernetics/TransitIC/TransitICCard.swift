//
//  TransitICCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 交通系ICカードから読み取ることができるデータの種別
public enum TransitICCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// 取引履歴
    case transactions
    
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x008B
        case .transactions:
            return 0x090F
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .transactions:
            return 20
        }
    }
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
    public var data: [FeliCaServiceCode : [Data]] = [:]
    
    public var balance: Int?
    public var transactionsData: [Data]?
    
    @available(iOS 13.0, *)
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.idm = idm
        self.systemCode = systemCode
    }
}
