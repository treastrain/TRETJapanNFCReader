//
//  ICUCard.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// ICU Student ID Card
@available(iOS 13.0, *)
public struct ICUCard: FeliCaCard {
    public let tag: ICUCardTag
    public var data: ICUCardData
    
    public init(from fcfCampusCard: FCFCampusCard) {
        self.tag = fcfCampusCard.tag
        self.data = ICUCardData(from: fcfCampusCard.data)
    }
    
    public init(tag: ICUCardTag, data: ICUCardData) {
        self.tag = tag
        self.data = data
    }
}

#endif
