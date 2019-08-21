//
//  CommonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 共通領域
@available(iOS 13.0, *)
public struct CommonCard: FeliCaCard {
    public var tag: CommonCardTag
    public var type: FeliCaCardType
    public var idm: String
    public var systemCode: FeliCaSystemCode
    
    
}
