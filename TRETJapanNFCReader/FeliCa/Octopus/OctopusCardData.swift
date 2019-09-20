//
//  OctopusCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// Octopus Card Data
public struct OctopusCardData: FeliCaCardData {
    public var type: FeliCaCardType = .octopus
    public var idm: String
    public var systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    
    @available(iOS 13.0, *)
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.idm = idm
        self.systemCode = systemCode
    }
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch OctopusCardItemType(key) {
            case .balance:
                self.convertToBalance(blockData)
            case .none:
                break
            }
        }
    }
    
    private mutating func convertToBalance(_ blockData: [Data]) {
        let data = blockData.first!
        var balance = 0
        balance += Int(data[0])
        balance += Int(data[1] << 8)
        balance += Int(data[2] << 16)
        balance += Int(data[3] << 24)
        balance -= 500
        self.balance = balance
    }
    
}
