//
//  UnivCoopICPrepaidCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 大学生協ICプリペイドカード
@available(iOS 13.0, *)
public struct UnivCoopICPrepaidCard: FeliCaCard {
    public let tag: UnivCoopICPrepaidCardTag
    public var data: UnivCoopICPrepaidCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = UnivCoopICPrepaidCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: UnivCoopICPrepaidCardTag, data: UnivCoopICPrepaidCardData) {
        self.tag = tag
        self.data = data
    }
}

#endif
