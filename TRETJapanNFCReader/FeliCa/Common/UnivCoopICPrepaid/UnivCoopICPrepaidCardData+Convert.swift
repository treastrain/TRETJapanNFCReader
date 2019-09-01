//
//  UnivCoopICPrepaidCardData+Convert.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

extension UnivCoopICPrepaidCardData {
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch key {
            case UnivCoopICPrepaidItemType.balance.serviceCode:
                self.convertToBalance(blockData)
            case UnivCoopICPrepaidItemType.univCoopInfo.serviceCode:
                self.convertToUnivCoopInfo(blockData)
            case UnivCoopICPrepaidItemType.transactions.serviceCode:
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
