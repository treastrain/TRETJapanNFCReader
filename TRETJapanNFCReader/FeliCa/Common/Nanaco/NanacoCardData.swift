//
//  NanacoCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// nanacoカードのデータ
public struct NanacoCardData: FeliCaCardData {
    public let type: FeliCaCardType = .nanaco
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    
    @available(iOS 13.0, *)
    internal init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
        self.data = feliCaCommonCardData.data
    }
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch key {
            case NanacoCardItemType.balance.serviceCode:
                self.convertToBalance(blockData)
            default:
                break
            }
        }
    }
    
    public mutating func convertToBalance(_ blockData: [Data]) {
        let data = blockData.first!
        let balance = data.toIntReversed(0, 3)
        self.balance = balance
    }
}
