//
//  LocalTransitICCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 地方交通系ICカード
@available(iOS 13.0, *)
public struct LocalTransitICCard: FeliCaCard {
    public let tag: LocalTransitICCardTag
    public var data: LocalTransitICCardData
    
    public init(tag: LocalTransitICCardTag, data: LocalTransitICCardData) {
        self.tag = tag
        self.data = data
    }
}

@available(*, unavailable, renamed: "LocalTransitICCard")
public struct RyutoCard/*: FeliCaCard*/ {}
#endif
