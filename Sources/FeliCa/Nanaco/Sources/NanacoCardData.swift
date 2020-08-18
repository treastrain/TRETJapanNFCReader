//
//  NanacoCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// nanacoカードのデータ
public struct NanacoCardData: FeliCaCardData {
    public var version: String = "3"
    public var type: FeliCaCardType = .nanaco
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var nanacoNumber: String?
    public var points: Int?
    public var transactions: [NanacoCardTransaction]?
    
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
                    switch NanacoCardItemType(serviceCode) {
                    case .balance:
                        self.convertToBalance(blockData)
                    case .nanacoNumber:
                        self.convertToNanacoNumber(blockData)
                    case .points:
                        self.convertToPoints(blockData)
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
    
    private mutating func convertToNanacoNumber(_ blockData: [Data]) {
        let data = blockData.first!
        self.nanacoNumber = String(
            stride(from: 0, to: 7, by: 2)
                .map { data[$0].toString() + data[$0 + 1].toString() + "-" }
                .joined()
                .dropLast()
        )
    }
    
    private mutating func convertToPoints(_ blockData: [Data]) {
        let data = blockData.last!
        self.points = data.toInt(from: 0, to: 2) + data.toInt(from: 5, to: 7)
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [NanacoCardTransaction] = []
        for data in blockData {
            
            let type: FeliCaCardTransactionType
            let otherType: NanacoCardTransactionType?
            switch data[0] {
            case 0x47:
                type = .purchase
                otherType = nil
            case 0x5C, 0x6F, 0x70:
                type = .credit
                otherType = nil
            case 0x35:
                type = .other
                otherType = .transfer
            case 0x83:
                type = .other
                otherType = .pointExchange
            default:
                continue
            }
            
            var dateComponents = DateComponents()
            dateComponents.calendar = self.calendar
            dateComponents.timeZone = dateComponents.calendar?.timeZone
            dateComponents.era = 1
            dateComponents.year = data.toInt(from: 9, to: 10) >> 5 + 2000
            dateComponents.month = Int(data[10] >> 1 & 0xF)
            dateComponents.day = data.toInt(from: 10, to: 11) >> 4 & 0x1F
            dateComponents.hour = data.toInt(from: 11, to: 12) >> 6 & 0x3F
            dateComponents.minute = Int(data[12] & 0x3F)
            guard let date = self.calendar.date(from: dateComponents) else {
                continue
            }
            
            let difference = data.toInt(from: 1, to: 4)
            let balance = data.toInt(from: 5, to: 8)
            
            transactions.append(NanacoCardTransaction(date: date, type: type, otherType: otherType, difference: difference, balance: balance))
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

/// nanacoカードの利用履歴
public struct NanacoCardTransaction: FeliCaCardTransaction {
    public let date: Date
    public let type: FeliCaCardTransactionType
    public let otherType: NanacoCardTransactionType?
    public let difference: Int
    public let balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, otherType: NanacoCardTransactionType? = nil, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.otherType = otherType
        self.difference = difference
        self.balance = balance
    }
}

/// nanacoカードから読み取る事ができるnanaco利用履歴のデータの種別
public enum NanacoCardTransactionType: String, Codable {
    /// 引き継ぎ
    case transfer
    /// ポイント交換によるチャージ
    case pointExchange
}
