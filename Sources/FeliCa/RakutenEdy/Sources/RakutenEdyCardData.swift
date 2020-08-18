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
    public var type: FeliCaCardType = .rakutenEdy
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
    
    private lazy var calendar = Calendar.asiaTokyo
    
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
    
    public mutating func convert() {
        for (systemCode, system) in self.contents {
            switch systemCode {
            case self.primarySystemCode:
                let services = system.services
                for (serviceCode, blockData) in services {
                    guard blockData.statusFlag.isSucceeded else {
                        continue
                    }
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
        self.edyNumber = stride(from: 2, to: 9, by: 2)
            .map { data[$0].toString() + data[$0 + 1].toString() + " " }
            .joined()
            .trimmingCharacters(in: .whitespaces)
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [RakutenEdyCardTransaction] = []
        for data in blockData {
            var type: FeliCaCardTransactionType
            switch data[0] {
            case 0x02, 0x04:
                type = .credit
            case 0x20:
                type = .purchase
            default:
                continue
            }
            
            let date20000101 = Date(timeIntervalSince1970: 946652400)
            let day = data.toInt(from: 4, to: 5) >> 1
            let second = data.toInt(from: 5, to: 7) & 0x1FFFF
            guard let dateAddedDay = self.calendar.date(byAdding: .day, value: day, to: date20000101),
                  let date = self.calendar.date(byAdding: .second, value: second, to: dateAddedDay) else {
                continue
            }
            
            let difference = data.toInt(from: 8, to: 11)
            let balance = data.toInt(from: 12, to: 15)
            
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
    public let date: Date
    public let type: FeliCaCardTransactionType
    public let difference: Int
    public let balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.difference = difference
        self.balance = balance
    }
}
