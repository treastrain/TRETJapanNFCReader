//
//  WaonCard+Convert.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

extension WaonCardData {
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch key {
            case WaonCardItemType.balance.serviceCode:
                self.convertToBalance(blockData)
            case WaonCardItemType.waonNumber.serviceCode:
                self.convertToWaonNumber(blockData)
            case WaonCardItemType.points.serviceCode:
                self.convertToPoints(blockData)
            case WaonCardItemType.transactions.serviceCode:
                self.convertToTransactions(blockData)
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
        self.waonNumber = data[0].toString() + data[1].toString() + " " + data[2].toString() + data[3].toString() + " " + data[4].toString() + data[5].toString() + " " + data[6].toString() + data[7].toString()
    }
    
    private mutating func convertToPoints(_ blockData: [Data]) {
        let data = blockData.first!
        self.points = Int(UInt32(data[0]) << 16 + UInt32(data[1]) << 8 + UInt32(data[2]))
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        var transactions: [WaonCardTransaction] = []
        for i in stride(from: 1, to: 6, by: 2) {
            let data = blockData[i]
            let data1 = UInt8(data[1])
            
            var type = FeliCaCardTransactionType.unknown
            var otherType: WaonCardTransactionType!
            switch data1 {
            case 0x04:
                type = .purchase
            case 0x0C, 0x10:
                type = .credit
            default:
                type = .other
                switch data1 {
                case 0x08:
                    otherType = .returned
                case 0x18:
                    otherType = .pointDownload
                case 0x28:
                    otherType = .refunded
                case 0x1C, 0x20, 0x30:
                    otherType = .autoCredit
                case 0x3C:
                    otherType = .moveToNewCard
                case 0x7C:
                    otherType = .pointExchange
                default:
                    continue
                }
            }
            
            let data2 = UInt16(data[2])
            let data3 = UInt16(data[3])
            let data4 = UInt16(data[4])
            let data5 = UInt16(data[5])
            let data6 = UInt32(data[6]) << 8
            let data7 = UInt32(data[7])
            let data8 = UInt32(data[8]) << 8
            let data9 = UInt32(data[9])
            let data10 = UInt32(data[10]) << 8
            let data11 = UInt32(data[11])
            
            let year = Int(data2 >> 3) + 2005
            let month = Int((((data2 << 8) + data3) << 5) >> 12)
            let day = Int((UInt8(data3) << 1) >> 3)
            let hour = Int((((data3 << 8) + data4) << 6) >> 11)
            let minute = Int((((data4 << 8) + data5) << 3) >> 10)
            let dateString = "\(year)-\(month)-\(day) \(hour):\(minute)"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-M-d H:m"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            guard let date = formatter.date(from: dateString) else {
                continue
            }
            let balance = Int((((UInt32(data5) & 0x7F) << 16) + data6 + data7) >> 5)
            var difference = 0
            difference = Int((((data7 & 0x1F) << 16) + data8 + data9) >> 3)
            if difference <= 0 {
                difference = Int((((data9 & 0x7) << 16) + data10 + data11) >> 2)
            }
            
            transactions.append(WaonCardTransaction(date: date, type: type, otherType: otherType, difference: difference, balance: balance))
        }
        transactions.sort {
            return $0.date > $1.date
        }
        self.transactions = transactions
    }
}
