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

    private mutating func convertToIdentity(_ blockData: [Data]) {
        self.id = nil
        self.name = nil
        if blockData.count < 2 {
            return
        }
        
        // get student ID
        self.id = blockData[0][2...7].reduce(0) { (stack, digit) in
            return stack * 10 + Int(digit & 0x0F)
        }
    }
}
