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
    
    /// The real balance is (`balance` - Offset) / 10
    /// (e.g.  (4557 - 350) / 10 = HK$420.7 )
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
        balance += Int(UInt32(data[0]) << 24)
        balance += Int(UInt32(data[1]) << 16)
        balance += Int(UInt32(data[2]) << 8)
        balance += Int(data[3])
        self.balance = balance
    }
    
}
