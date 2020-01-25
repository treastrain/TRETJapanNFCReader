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
    public let type: FeliCaCardType = .nanaco
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
    
    public mutating func convertToBalance(_ blockData: [Data]) {
        let data = blockData.first!
        let balance = data.toIntReversed(0, 3)
        self.balance = balance
    }
    
    private mutating func convertToNanacoNumber(_ blockData: [Data]) {
        let data = blockData.first!
        self.nanacoNumber = data[0].toString() + data[1].toString() + "-" + data[2].toString() + data[3].toString() + "-" + data[4].toString() + data[5].toString() + "-" + data[6].toString() + data[7].toString()
    }
    
    private mutating func convertToPoints(_ blockData: [Data]) {
        let data = blockData.last!
        let points1 = Int((UInt32(data[0]) << 16) + (UInt32(data[1]) << 8) + UInt32(data[2]))
        let points2 = Int((UInt32(data[5]) << 16) + (UInt32(data[6]) << 8) + UInt32(data[7]))
        self.points = points1 + points2
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [NanacoCardTransaction] = []
        for data in blockData {
            
            var type = FeliCaCardTransactionType.unknown
            var otherType: NanacoCardTransactionType?
            switch data[0] {
            case 0x47:
                type = .purchase
            case 0x5C, 0x6F, 0x70:
                type = .credit
            case 0x35:
                type = .other
                otherType = .transfer
            case 0x83:
                type = .other
                otherType = .pointExchange
            default:
                continue
            }
            
            let data1 = UInt32(data[1]) << 24
            let data2 = UInt32(data[2]) << 16
            let data3 = UInt32(data[3]) << 8
            let data4 = UInt32(data[4])
            let difference = Int(data1 + data2 + data3 + data4)
            
            let data5 = UInt32(data[5]) << 24
            let data6 = UInt32(data[6]) << 16
            let data7 = UInt32(data[7]) << 8
            let data8 = UInt32(data[8])
            let balance = Int(data5 + data6 + data7 + data8)
            
            let data9 = UInt16(data[9]) << 8
            let data10 = data[10]
            let data11 = UInt16(data[11])
            let data12 = data[12]
            
            let year = Int((data9 + UInt16(data10)) >> 5) + 2000
            let month = Int((data10 << 3) >> 4)
            let day = Int((((UInt16(data10) << 8) + data11) << 7) >> 11)
            let hour = Int((((data11 << 8) + UInt16(data12)) << 4) >> 10)
            let minute = Int(data12 & 0x3F)
            let dateString = "\(year)-\(month)-\(day) \(hour):\(minute)"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-M-d H:m"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            guard let date = formatter.date(from: dateString) else {
                continue
            }
            
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
    public var balance: Int
    
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
