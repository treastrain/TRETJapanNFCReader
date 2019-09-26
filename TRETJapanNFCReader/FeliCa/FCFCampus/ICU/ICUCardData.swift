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

    @available(iOS 13.0, *)
    internal init(from fcfCampusCardData: FCFCampusCardData) {
        self.idm = fcfCampusCardData.idm
        self.systemCode = fcfCampusCardData.systemCode
        self.data = fcfCampusCardData.data
    }

    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch ICUItemType(key) {
            case .identity:
                self.convertToIdentity(blockData)
            case .transactions:
                self.convertToTransactions(blockData)
            case .none:
                break
            }
        }
    }
}
