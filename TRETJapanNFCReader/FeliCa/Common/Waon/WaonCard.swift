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
