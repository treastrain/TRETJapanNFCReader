//
//  RyutoCard.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// りゅーと
@available(iOS 13.0, *)
public struct RyutoCard: FeliCaCard {
    public let tag: RyutoCardTag
    public var data: RyutoCardData
    
    public init(tag: RyutoCardTag, data: RyutoCardData) {
        self.tag = tag
        self.data = data
    }
}
#endif
