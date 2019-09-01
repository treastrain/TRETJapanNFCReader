//
//  NanacoCard+Convert.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

extension NanacoCardData {
    
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
