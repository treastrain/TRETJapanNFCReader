//
//  UnivCoopICPrepaidCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 大学生協ICプリペイドカードのデータ
public struct UnivCoopICPrepaidCardData: FeliCaCardData {
    public let type: FeliCaCardType = .univCoopICPrepaid
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var membershipNumber: String?
    public var mealCardUser: Bool?
    public var mealCardLastUseDate: Date?
    public var mealCardLastUsageAmount: Int?
    public var points: Double?
    public var transactions: [UnivCoopICPrepaidCardTransaction]?
    
    @available(iOS 13.0, *)
    internal init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
        self.data = feliCaCommonCardData.data
    }
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch UnivCoopICPrepaidItemType(key) {
            case .balance:
                self.convertToBalance(blockData)
            case .univCoopInfo:
                self.convertToUnivCoopInfo(blockData)
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
    
    private mutating func convertToUnivCoopInfo(_ blockData: [Data]) {
        for (i, data) in blockData.enumerated() {
            switch i {
            case 0:
                self.membershipNumber = data[0].toString() + data[1].toString() + data[2].toString() + data[3].toString() + data[4].toString() + data[5].toString()
            case 1:
                if Int(data[0]) == 0 {
                    self.mealCardUser = false
                } else if Int(data[0]) == 1 {
                    self.mealCardUser = true
                }
                if var year = Int(data[2].toString()), let month = Int(data[3].toString()), let day = Int(data[4].toString()) {
                    year += 2000
                    let dateString = "\(year)/\(month)/\(day)"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    self.mealCardLastUseDate = formatter.date(from: dateString)
                    self.mealCardLastUsageAmount = Int(data[5].toString() + data[6].toString() + data[7].toString())
                }
            case 2:
                if let pointsInt = Int("\(data[0].toString())\(data[1].toString())\(data[2].toString())\(data[3].toString())", radix: 16) {
                    self.points = Double(pointsInt) / 10.0
                }
            default:
                break
            }
        }
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [UnivCoopICPrepaidCardTransaction] = []
        for data in blockData {
            
            let dateString = data[0].toString() + data[1].toString() + data[2].toString() + data[3].toString() + data[4].toString() + data[5].toString() + data[6].toString()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            guard let date = formatter.date(from: dateString) else {
                continue
            }
            
            var type = FeliCaCardTransactionType.unknown
            if Int(data[7]) == 5 {
                type = .purchase
            } else if Int(data[7]) == 1 {
                type = .credit
            }
            
            let difference = Int(data[8].toString() + data[9].toString() + data[10].toString())
            let balance = Int(data[11].toString() + data[12].toString() + data[13].toString())
            
            if let difference = difference, let balance = balance {
                transactions.append(UnivCoopICPrepaidCardTransaction(date: date, type: type, difference: difference, balance: balance))
            }
        }
        self.transactions = transactions
    }
}

/// 大学生協ICプリペイドカードの利用履歴
public struct UnivCoopICPrepaidCardTransaction: FeliCaCardTransaction {
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
