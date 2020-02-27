//
//  RakutenEdyCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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

#endif
