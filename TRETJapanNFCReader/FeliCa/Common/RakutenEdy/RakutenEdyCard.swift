//
//  RakutenEdyCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 楽天Edyカードから読み取ることができるデータの種別
public enum RakutenEdyCardItem: CaseIterable, FeliCaCardItem {
    /// カード残高
    case balance
}

/// 楽天Edyカード
@available(iOS 13.0, *)
public struct RakutenEdyCard: FeliCaCard {
    public var tag: RakutenEdyCardTag
    public let type: FeliCaCardType = .rakutenEdy
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    public var balance: Int?
}
