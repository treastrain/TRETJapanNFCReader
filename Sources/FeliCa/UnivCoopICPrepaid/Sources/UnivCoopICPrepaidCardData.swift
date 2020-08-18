//
//  UnivCoopICPrepaidCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 大学生協ICプリペイドカードのデータ
public struct UnivCoopICPrepaidCardData: FeliCaCardData {
    public var version: String = "3"
    public var type: FeliCaCardType = .univCoopICPrepaid
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
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
                    switch UnivCoopICPrepaidItemType(serviceCode) {
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
    
    private mutating func convertToUnivCoopInfo(_ blockData: [Data]) {
        for (index, data) in zip(blockData.indices, blockData) {
            switch index {
            case 0:
                self.membershipNumber = data.prefix(6).map { $0.toString() }.joined()
            case 1:
                self.mealCardUser = data[0] != 0
                var dateComponents = DateComponents()
                dateComponents.calendar = self.calendar
                dateComponents.timeZone = dateComponents.calendar?.timeZone
                dateComponents.era = 1
                dateComponents.year = Int("20\(data[2].toString())")
                dateComponents.month = Int(data[3].toString())
                dateComponents.day = Int(data[4].toString())
                print(dateComponents)
                self.mealCardLastUseDate = Calendar(identifier: .gregorian).date(from: dateComponents)
                self.mealCardLastUsageAmount = Int(data[5...7].map { $0.toString() }.joined())
            case 2:
                if let pointsInt = Int(data.prefix(4).map { $0.toString() }.joined(), radix: 16) {
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
            let calendar = Calendar(identifier: .gregorian)
            var dateComponents = DateComponents()
            dateComponents.calendar = calendar
            dateComponents.timeZone = TimeZone(identifier: "Asia/Tokyo")
            dateComponents.era = 1
            dateComponents.year = Int(data.prefix(2).map { $0.toString() }.joined())
            dateComponents.month = Int(data[2].toString())
            dateComponents.day = Int(data[3].toString())
            dateComponents.hour = Int(data[4].toString())
            dateComponents.minute = Int(data[5].toString())
            dateComponents.second = Int(data[6].toString())
            guard let date = calendar.date(from: dateComponents) else {
                continue
            }
            
            let type: FeliCaCardTransactionType
            switch data[7] {
            case 1:
                type = .credit
            case 5:
                type = .purchase
            default:
                type = .unknown
            }
            
            let difference = Int(data[8...10].map { $0.toString() }.joined())
            let balance = Int(data[11...13].map { $0.toString() }.joined())
            
            if let difference = difference, let balance = balance {
                transactions.append(UnivCoopICPrepaidCardTransaction(date: date, type: type, difference: difference, balance: balance))
            }
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
