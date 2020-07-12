//
//  TransitICCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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

#endif
