//
//  WaonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// WAONカードから読み取る事ができるデータの種別
public enum WaonCardItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
}

/// WAONカード
@available(iOS 13.0, *)
public struct WaonCard: FeliCaCard {
    public var tag: WaonCardTag
    public var type: FeliCaCardType = .waon
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    public var balance: Int?
    
    public init(from feliCaCard: FeliCaCard) {
        self.tag = feliCaCard.tag
        self.idm = feliCaCard.idm
        self.systemCode = feliCaCard.systemCode
    }
    
    public init(tag: WaonCardTag, idm: String, systemCode: FeliCaSystemCode, balance: Int? = nil) {
        self.tag = tag
        self.idm = idm
        self.systemCode = systemCode
        self.balance = balance
    }
}
