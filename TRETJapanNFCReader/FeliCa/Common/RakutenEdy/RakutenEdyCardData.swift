//
//  RakutenEdyCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 楽天Edyカードのデータ
public struct RakutenEdyCardData: FeliCaCardData {
    public let type: FeliCaCardType = .rakutenEdy
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var edyNumber: String?
    public var transactions: [RakutenEdyCardTransaction]?
    
    @available(iOS 13.0, *)
    internal init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
        self.data = feliCaCommonCardData.data
    }
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch RakutenEdyCardItemType(key) {
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
