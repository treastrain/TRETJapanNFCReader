//
//  NTasuCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation

/// エヌタス
@available(iOS 13.0, *)
public struct NTasuCard: FeliCaCard {
    public let tag: NTasuCardTag
    public var data: NTasuCardData
}

#endif
