//
//  RakutenEdyReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension RakutenEdyReader {
    
    public func readBalance(_ session: NFCTagReaderSession, _ rakutenEdyCard: RakutenEdyCard) -> RakutenEdyCard {
        let semaphore = DispatchSemaphore(value: 0)
        var rakutenEdyCard = rakutenEdyCard
        let tag = rakutenEdyCard.tag
        
        let serviceCode = Data([0x13, 0x17].reversed())
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
            rakutenEdyCard.data.balance = balance
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return rakutenEdyCard
    }
    
    public func readEdyNumber(_ session: NFCTagReaderSession, _ rakutenEdyCard: RakutenEdyCard) -> RakutenEdyCard {
        let semaphore = DispatchSemaphore(value: 0)
        var rakutenEdyCard = rakutenEdyCard
        let tag = rakutenEdyCard.tag
        
        let serviceCode = Data([0x11, 0x0B].reversed())
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
            
            rakutenEdyCard.data.edyNumber = data[2].toString() + data[3].toString() + " " + data[4].toString() + data[5].toString() + " " + data[6].toString() + data[7].toString() + " " + data[8].toString() + data[9].toString()
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return rakutenEdyCard
    }
    
    public func readTransactions(_ session: NFCTagReaderSession, _ rakutenEdyCard: RakutenEdyCard) -> RakutenEdyCard {
        let semaphore = DispatchSemaphore(value: 0)
        var rakutenEdyCard = rakutenEdyCard
        let tag = rakutenEdyCard.tag
        
        let serviceCode = Data([0x17, 0x0F].reversed())
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
            
            var transactions: [RakutenEdyCardTransaction] = []
            for data in blockData {
                
                var type = FeliCaCardTransactionType.unknown
                if data[0] == 0x02 || data[0] == 0x04 {
                    type = .credit
                } else if data[0] == 0x20 {
                    type = .purchase
                } else {
                    continue
                }
                
                let day = Int(((UInt16(data[4]) << 8) + UInt16(data[5])) >> 1)
                let second = Int(((UInt32(data[5]) << 16) + (UInt32(data[6]) << 8) + UInt32(data[7])) & 0x1FFFF)
                var date = Date(timeIntervalSince1970: 946652400)
                date = Calendar.current.date(byAdding: .day, value: day, to: date)!
                date = Calendar.current.date(byAdding: .second, value: second, to: date)!
                
                let data8 = UInt32(data[8]) << 24
                let data9 = UInt32(data[9]) << 16
                let data10 = UInt32(data[10]) << 8
                let data11 = UInt32(data[11])
                let difference = Int(data8 + data9 + data10 + data11)
                
                let data12 = UInt32(data[12]) << 24
                let data13 = UInt32(data[13]) << 16
                let data14 = UInt32(data[14]) << 8
                let data15 = UInt32(data[15])
                let balance = Int(data12 + data13 + data14 + data15)
                
                transactions.append(RakutenEdyCardTransaction(date: date, type: type, difference: difference, balance: balance))
            }
            rakutenEdyCard.data.transactions = transactions
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return rakutenEdyCard
    }
}
