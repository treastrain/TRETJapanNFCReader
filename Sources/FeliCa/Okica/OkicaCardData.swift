//
//  OkicaCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// OKICA のデータ
public struct OkicaCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType = .okica
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var transactions: [OkicaCardTransaction]? {
        didSet {
            self.balance = transactions?.first?.balance
        }
    }
    public var entryExitInformationsData: [Data]?
    public var sfEntryInformationsData: [Data]?
    
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
                    switch OkicaCardItemType(serviceCode) {
                    case .transactions:
                        self.transactions = self.convertToTransactions(blockData)
                    case .entryExitInformations:
                        self.entryExitInformationsData = blockData
                    case .sfEntryInformations:
                        self.sfEntryInformationsData = blockData
                    case .none:
                        break
                    }
                }
            default:
                break
            }
        }
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) -> [OkicaCardTransaction] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        var transactions: [OkicaCardTransaction] = []
        
        for (i, data) in zip(blockData.indices, blockData) {
            if i >= blockData.count - 1 {
                continue
            }
            
            let dateString = self.dateString(from: data[4], data[5])
            guard let date = formatter.date(from: dateString) else {
                continue
            }
            
            var type: FeliCaCardTransactionType = .unknown
            var otherType: OkicaCardTransactionType? = nil
            var usageType = "不明"
            let usageTypeData = (UInt32(data[0]) << 24) + (UInt32(data[1]) << 16) + UInt32(data[2] << 8) + UInt32(data[3])
            switch usageTypeData {
            case 0x16010002:
                type = .transit
                usageType = "ゆいレール（移動）"
            case 0x08020000:
                type = .credit
                usageType = "ゆいレール（チャージ）"
            case 0x08480000, 0x08480400:
                type = .other
                otherType = .pointExchange
                usageType = "ポイントチャージ"
            case 0x051F0000:
                type = .credit
                usageType = "バス（チャージ）"
            case 0x050F000F:
                type = .transit
                usageType = "バス（移動）"
            case 0x08070000:
                type = .other
                otherType = .newIssue
                usageType = "新規発行"
            case 0x1F1F0000:
                type = .credit
                usageType = "チャージ機"
            default:
                break
            }
            
            print(i, data as NSData, usageTypeData, usageType)
            
            let entryStation = self.station(from: data[6], data[7])
            let exitedStation = self.station(from: data[8], data[9])
            let balance = data.toIntReversed(10, 11)
            let previousBalance = blockData[i + 1].toIntReversed(10, 11)
            let difference = balance - previousBalance
            let sequentialNumber = self.transactionSerialNumber(from: data[13], data[14])
            
            let transaction = OkicaCardTransaction(type: type, otherType: otherType, dateString: dateString, date: date, usageType: usageType, entryStation: entryStation, exitedStation: exitedStation, balance: balance, difference: difference, sequentialNumber: sequentialNumber)
            transactions.append(transaction)
        }
        
        return transactions
    }
    
    
    private func dateString(from data4: UInt8, _ data5: UInt8) -> String {
        let year = Int(data4 >> 1) + 2000
        let month = ((data4 & 0x1) << 3) + (data5 >> 5)
        let day = data5 & 0x1F
        return "\(year)/\(month)/\(day)"
    }
    
    public func station(from stationCode1: UInt8, _ stationCode2: UInt8) -> String {
        switch stationCode1 {
        case 0xDC:
            switch stationCode2 {
            case 0x01:
                return "那覇空港"
            case 0x03:
                return "03"
            case 0x05:
                return "赤嶺"
            case 0x07:
                return "小禄"
            case 0x09:
                return "奥武山公園"
            case 0x0B:
                return "壺川"
            case 0x0D:
                return "旭橋"
            case 0x0F:
                return "県庁前"
            case 0x11:
                return "美栄橋"
            case 0x13:
                return "牧志"
            case 0x15:
                return "安里"
            case 0x17:
                return "おもろまち"
            case 0x19:
                return "古島"
            case 0x1B:
                return "市立病院前"
            case 0x1D:
                return "儀保"
            case 0x1F:
                return "首里"
            case 0x21:
                return "石嶺"
            case 0x23:
                return "経塚"
            case 0x25:
                return "浦添前田"
            case 0x27:
                return "てだこ浦西"
            default:
                return ""
            }
        case 0x0B:
            switch stationCode2 {
            case 0x01:
                return "那覇バス"
            case 0x02:
                return "琉球バス交通"
            case 0x03:
                return "沖縄バス"
            case 0x04:
                return "東陽バス"
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    private func transactionSerialNumber(from dataD: UInt8, _ dataE: UInt8) -> String {
        let n = (UInt16(dataD) << 8) + UInt16(dataE)
        return "\(n)"
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}

/// OKICA の利用履歴
public struct OkicaCardTransaction: FeliCaCardTransaction {
    public let type: FeliCaCardTransactionType
    public let otherType: OkicaCardTransactionType?
    /// 日付（`String`）
    public let dateString: String
    /// 日付
    public let date: Date
    /// 利用種別
    public let usageType: String
    /// 入場駅
    public let entryStation: String
    /// 出場駅
    public let exitedStation: String
    /// 残高
    public let balance: Int
    /// 差額
    public let difference: Int
    /// 連番
    public let sequentialNumber: String
    
    
    public init(type: FeliCaCardTransactionType, otherType: OkicaCardTransactionType?, dateString: String, date: Date, usageType: String, entryStation: String, exitedStation: String, balance: Int, difference: Int, sequentialNumber: String) {
        self.type = type
        self.otherType = otherType
        self.dateString = dateString
        self.date = date
        self.usageType = usageType
        self.entryStation = entryStation
        self.exitedStation = exitedStation
        self.balance = balance
        self.difference = difference
        self.sequentialNumber = sequentialNumber
    }
}
