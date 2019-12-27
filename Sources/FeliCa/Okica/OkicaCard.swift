//
//  OkicaCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
import TRETJapanNFCReader_FeliCa

/// OKICA
@available(iOS 13.0, *)
public struct OkicaCard: FeliCaCard {
    public let tag: OkicaCardTag
    public var data: OkicaCardData
    
    public init(tag: OkicaCardTag, data: OkicaCardData) {
        self.tag = tag
        self.data = data
    }
}

#endif
