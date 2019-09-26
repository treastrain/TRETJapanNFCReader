//
//  ICUCardData.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct ICUCardData: FeliCaCardData {
    public let type: FeliCaCardType = .fcfcampus
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }

    public var id: Int?
    public var name: String?
    public var balance: Int?
    public var transactions: [ICUCardTransaction]?

}
