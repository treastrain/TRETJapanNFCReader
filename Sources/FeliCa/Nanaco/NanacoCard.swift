//
//  NanacoCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// nanacoカード
@available(iOS 13.0, *)
public struct NanacoCard: FeliCaCard {
    public let tag: NanacoCardTag
    public var data: NanacoCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = NanacoCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: NanacoCardTag, data: NanacoCardData) {
        self.tag = tag
        self.data = data
    }
}

#endif
