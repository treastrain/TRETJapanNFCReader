//
//  OctopusCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// Octopus Card (八達通)
@available(iOS 13.0, *)
public struct OctopusCard: FeliCaCard {
    public let tag: OctopusCardTag
    public var data: OctopusCardData
    
    public init(tag: OctopusCardTag, data: OctopusCardData) {
        self.tag = tag
        self.data = data
    }
}
