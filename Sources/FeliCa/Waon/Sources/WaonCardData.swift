//
//  WaonCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// WAONカードのデータ
public struct WaonCardData: FeliCaCardData {
    public var version: String = "3"
    public var type: FeliCaCardType = .waon
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var waonNumber: String?
    public var points: Int?
    public var transactions: [WaonCardTransaction]?
    
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
                    let blockData = blockData.blockData
                    switch WaonCardItemType(serviceCode) {
                    case .balance:
                        self.convertToBalance(blockData)
                    case .waonNumber:
                        self.convertToWaonNumber(blockData)
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
    
    private mutating func convertToWaonNumber(_ blockData: [Data]) {
        let data = blockData.first!
        self.waonNumber = stride(from: 0, to: 7, by: 2)
            .map { data[$0].toString() + data[$0 + 1].toString() + " " }
            .joined()
            .trimmingCharacters(in: .whitespaces)
    }
    
    private mutating func convertToPoints(_ blockData: [Data]) {
        let data = blockData.first!
        self.points = data.toInt(from: 0, to: 2)
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [WaonCardTransaction] = []
        for i in stride(from: 1, to: 6, by: 2) {
            let data = blockData[i]
            
            let type: FeliCaCardTransactionType
            let otherType: WaonCardTransactionType?
            switch data[1] {
            case 0x04:
                type = .purchase
                otherType = nil
            case 0x0C, 0x10:
                type = .credit
                otherType = nil
            case 0x08:
                type = .other
                otherType = .returned
            case 0x18:
                type = .other
                otherType = .pointDownload
            case 0x28:
                type = .other
                otherType = .refunded
            case 0x1C, 0x20, 0x30:
                type = .other
                otherType = .autoCredit
            case 0x3C:
                type = .other
                otherType = .moveToNewCard
            case 0x7C:
                type = .other
                otherType = .pointExchange
            default:
                continue
            }
            
            var dateComponents = DateComponents()
            dateComponents.calendar = self.calendar
            dateComponents.timeZone = dateComponents.calendar?.timeZone
            dateComponents.era = 1
            dateComponents.year = Int(data[2] >> 3) + 2005
            dateComponents.month = data.toInt(from: 2, to: 3) >> 7 & 0xF
            dateComponents.day = Int(data[3] >> 2 & 0x1F)
            dateComponents.hour = data.toInt(from: 3, to: 4) >> 5 & 0x1F
            dateComponents.minute = data.toInt(from: 4, to: 5) >> 7 & 0x3F
            guard let date = self.calendar.date(from: dateComponents) else {
                continue
            }
            
            let balance = data.toInt(from: 5, to: 7) >> 5 & 0x3FFFF
            var difference = data.toInt(from: 7, to: 9) >> 3 & 0x3FFFF
            if difference <= 0 {
                difference = data.toInt(from: 9, to: 11) >> 2 & 0x1FFFF
            }
            
            transactions.append(WaonCardTransaction(date: date, type: type, otherType: otherType, difference: difference, balance: balance))
        }
        transactions.sort {
            return $0.date > $1.date
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

/// WAONカードの利用履歴
public struct WaonCardTransaction: FeliCaCardTransaction {
    public let date: Date
    public let type: FeliCaCardTransactionType
    public let otherType: WaonCardTransactionType?
    public let difference: Int
    public let balance: Int
    
    public init(date: Date, type: FeliCaCardTransactionType, otherType: WaonCardTransactionType? = nil, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.otherType = otherType
        self.difference = difference
        self.balance = balance
    }
}

/// WAONカードから読み取る事ができるWAON利用履歴のデータの種別
public enum WaonCardTransactionType: String, Codable {
    /// 返品
    case returned
    /// ポイントダウンロード
    case pointDownload
    /// 返金
    case refunded
    /// オートチャージ
    case autoCredit
    /// 新カードへ移行
    case moveToNewCard
    /// ポイント交換
    case pointExchange
}
