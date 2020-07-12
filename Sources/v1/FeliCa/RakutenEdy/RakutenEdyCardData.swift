//
//  RakutenEdyCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 楽天Edyカードのデータ
public struct RakutenEdyCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType = .rakutenEdy
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var edyNumber: String?
    public var transactions: [RakutenEdyCardTransaction]?
    
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
    }
    
    public init(idm: String, systemCode: FeliCaSystemCode, data: FeliCaData) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
        self.contents = data
        self.convert()
    }
    
    @available(iOS 13.0, *)
    internal init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.primaryIDm = feliCaCommonCardData.primaryIDm
        self.primarySystemCode = feliCaCommonCardData.primarySystemCode
        self.contents = feliCaCommonCardData.contents
    }
    
    public mutating func convert() {
        for (systemCode, system) in self.contents {
            switch systemCode {
            case self.primarySystemCode:
                let services = system.services
                for (serviceCode, blockData) in services {
                    let blockData = blockData.blockData
                    switch RakutenEdyCardItemType(serviceCode) {
                    case .balance:
                        self.convertToBalance(blockData)
                    case .edyNumber:
                        self.convertToEdyNumber(blockData)
                    case .transactions:
                        self.convertToTransactions(blockData)
                    case .none:
                        break
                    }
                }
            default:
                break
            }
        }
    }
    
    private mutating func convertToBalance(_ blockData: [Data]) {
        let data = blockData.first!
        let balance = data.toIntReversed(0, 3)
        self.balance = balance
    }
    
    private mutating func convertToEdyNumber(_ blockData: [Data]) {
        let data = blockData.first!
        self.edyNumber = data[2].toString() + data[3].toString() + " " + data[4].toString() + data[5].toString() + " " + data[6].toString() + data[7].toString() + " " + data[8].toString() + data[9].toString()
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [RakutenEdyCardTransaction] = []
        for data in blockData {
            
            var type = FeliCaCardTransactionType.unknown
            if data[0] == 0x02 || data[0] == 0x04 {
                type = .credit
            } else if data[0] == 0x20 {
                type = .purchase
            } else {
                continue
            }
            
            let day = Int(((UInt16(data[4]) << 8) + UInt16(data[5])) >> 1)
            let second = Int(((UInt32(data[5]) << 16) + (UInt32(data[6]) << 8) + UInt32(data[7])) & 0x1FFFF)
            var date = Date(timeIntervalSince1970: 946652400)
            date = Calendar.current.date(byAdding: .day, value: day, to: date)!
            date = Calendar.current.date(byAdding: .second, value: second, to: date)!
            
            let data8 = UInt32(data[8]) << 24
            let data9 = UInt32(data[9]) << 16
            let data10 = UInt32(data[10]) << 8
            let data11 = UInt32(data[11])
            let difference = Int(data8 + data9 + data10 + data11)
            
            let data12 = UInt32(data[12]) << 24
            let data13 = UInt32(data[13]) << 16
            let data14 = UInt32(data[14]) << 8
            let data15 = UInt32(data[15])
            let balance = Int(data12 + data13 + data14 + data15)
            
            transactions.append(RakutenEdyCardTransaction(date: date, type: type, difference: difference, balance: balance))
        }
        self.transactions = transactions
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}

/// 楽天Edyカードの利用履歴
public struct RakutenEdyCardTransaction: FeliCaCardTransaction {
    public var date: Date
    public var type: FeliCaCardTransactionType
    public var difference: Int
    public var balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.difference = difference
        self.balance = balance
    }
}
