//
//  UnivCoopICPrepaidReaderFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension UnivCoopICPrepaidReader {
    
    public func readBalance(_ session: NFCTagReaderSession, _ univCoopICPrepaidCard: UnivCoopICPrepaidCard) -> UnivCoopICPrepaidCard {
        let semaphore = DispatchSemaphore(value: 0)
        var univCoopICPrepaidCard = univCoopICPrepaidCard
        let tag = univCoopICPrepaidCard.tag
        
        let serviceCode = Data([0x50, 0xD7].reversed())
        let blockList = [Data([0x80, 0x00])]
        
        tag.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList) { (status1, status2, blockData, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard status1 == 0x00, status2 == 0x00 else {
                print("ステータスフラグがエラーを示しています", status1, status2)
                session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                return
            }
            
            let data = blockData.first!
            
            let balance = data.toIntReversed(0, 3)
            univCoopICPrepaidCard.data.balance = balance
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return univCoopICPrepaidCard
    }
    
    public func readUnivCoopInfo(_ session: NFCTagReaderSession, _ univCoopICPrepaidCard: UnivCoopICPrepaidCard) -> UnivCoopICPrepaidCard {
        let semaphore = DispatchSemaphore(value: 0)
        var univCoopICPrepaidCard = univCoopICPrepaidCard
        let tag = univCoopICPrepaidCard.tag
        
        let serviceCode = Data([0x50, 0xCB].reversed())
        
        let blockList = (0..<6).map { (block) -> Data in
            Data([0x80, UInt8(block)])
        }
        
        tag.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList) { (status1, status2, blockData, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard status1 == 0x00, status2 == 0x00 else {
                print("ステータスフラグがエラーを示しています", status1, status2)
                session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                return
            }
            
            for (i, data) in blockData.enumerated() {
                switch i {
                case 0:
                    univCoopICPrepaidCard.data.membershipNumber = data[0].toString() + data[1].toString() + data[2].toString() + data[3].toString() + data[4].toString() + data[5].toString()
                case 1:
                    if Int(data[0]) == 0 {
                        univCoopICPrepaidCard.data.mealCardUser = false
                    } else if Int(data[0]) == 1 {
                        univCoopICPrepaidCard.data.mealCardUser = true
                    }
                    if var year = Int(data[2].toString()), let month = Int(data[3].toString()), let day = Int(data[4].toString()) {
                        year += 2000
                        let dateString = "\(year)/\(month)/\(day)"
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy/MM/dd"
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        univCoopICPrepaidCard.data.mealCardLastUseDate = formatter.date(from: dateString)
                        univCoopICPrepaidCard.data.mealCardLastUsageAmount = Int(data[5].toString() + data[6].toString() + data[7].toString())
                    }
                case 2:
                    if let pointsInt = Int("\(data[0].toString())\(data[1].toString())\(data[2].toString())\(data[3].toString())", radix: 16) {
                        univCoopICPrepaidCard.data.points = Double(pointsInt) / 10.0
                    }
                default:
                    break
                }
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return univCoopICPrepaidCard
    }
    
    public func readTransactions(_ session: NFCTagReaderSession, _ univCoopICPrepaidCard: UnivCoopICPrepaidCard) -> UnivCoopICPrepaidCard {
        let semaphore = DispatchSemaphore(value: 0)
        var univCoopICPrepaidCard = univCoopICPrepaidCard
        let tag = univCoopICPrepaidCard.tag
        
        let serviceCode = Data([0x50, 0xCF].reversed())
        
        let blockList = (0..<10).map { (block) -> Data in
            Data([0x80, UInt8(block)])
        }
        
        tag.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList) { (status1, status2, blockData, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard status1 == 0x00, status2 == 0x00 else {
                print("ステータスフラグがエラーを示しています", status1, status2)
                session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                return
            }
            
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
            univCoopICPrepaidCard.data.transactions = transactions
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return univCoopICPrepaidCard
    }
}
