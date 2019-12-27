//
//  WaonCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
import TRETJapanNFCReader_FeliCa

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

#endif
