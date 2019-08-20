//
//  TransitICReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension TransitICReader {
    
    internal func readBalance2(_ session: NFCTagReaderSession, _ transitICCard: TransitICCard) -> TransitICCard {
        let semaphore = DispatchSemaphore(value: 0)
        var transitICCard = transitICCard
        let tag = transitICCard.tag
        
        let nodeCode = Data([0x00, 0x8B].reversed())
        tag.requestService(nodeCodeList: [nodeCode]) { (nodeKeyVersionList, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard let nodeKeyVersion = nodeKeyVersionList.first, nodeKeyVersion != Data([0xFF, 0xFF]) else {
                print("指定したノードが存在しません")
                session.invalidate(errorMessage: "指定したノードが存在しません")
                return
            }
            
            let blockList = (0..<12).map { (block) -> Data in
                Data([0x80, UInt8(block)])
            }
            
            tag.readWithoutEncryption(serviceCodeList: [nodeCode], blockList: blockList) { (status1, status2, blockData, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: error.localizedDescription)
                    return
                } else {
                    print("status1:", UInt8(status1).toHexString(), "status2:", UInt8(status2).toHexString(), blockData)
                }
                
                guard status1 == 0x00, status2 == 0x00 else {
                    print("ステータスフラグがエラーを示しています", status1, status2)
                    session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                    return
                }
                
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        return transitICCard
    }
    
    internal func readBalance(_ session: NFCTagReaderSession, _ transitICCard: TransitICCard) -> TransitICCard {
        let semaphore = DispatchSemaphore(value: 0)
        var transitICCard = transitICCard
        let tag = transitICCard.tag
        
        let nodeCode = Data([0x09, 0x0f].reversed())
        tag.requestService(nodeCodeList: [nodeCode]) { (nodesData, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard let nodeData = nodesData.first, nodeData != Data([0xFF, 0xFF]) else {
                print("選択された node のサービスが存在しません")
                session.invalidate(errorMessage: "選択された node のサービスが存在しません")
                return
            }
            
            let blockList = (0..<12).map { (block) -> Data in
                Data([0x80, UInt8(block)])
            }
            
            tag.readWithoutEncryption(serviceCodeList: [nodeCode], blockList: blockList) { (status1, status2, blockData, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: error.localizedDescription)
                    return
                } else {
                    print("status1:", UInt8(status1).toHexString(), "status2:", UInt8(status2).toHexString(), blockData)
                }
                
                guard status1 == 0x00, status2 == 0x00 else {
                    print("ステータスフラグがエラーを示しています", status1, status2)
                    session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                    return
                }
                
                let data = blockData.first!
                let balance = Int(data[10]) + Int(data[11]) << 8
                transitICCard.balance = balance
                
                blockData.forEach { data in
                    print()
                    print("端末種: ", Int(data[0]))
                    print("処理: ", Int(data[1]))
                    
                    print("年: ", Int(data[4] >> 1) + 2000)
                    print("月: ", ((data[4] & 1) == 1 ? 8 : 0) + Int(data[5] >> 5))
                    print("日: ", Int(data[5] & 0x1f))
                    
                    print("入場駅コード: ", data[6...7].map { String(format: "%02x", $0) }.joined())
                    print("出場駅コード: ", data[8...9].map { String(format: "%02x", $0) }.joined())
                    print("入場地域コード: ", String(Int(data[15] >> 6), radix: 16))
                    print("出場地域コード: ", String(Int((data[15] & 0x30) >> 4), radix: 16))
                    
                    print("出場地区コード: ")
                    print("出場線区コード: ")
                    print("出場駅順コード: ")
                    
                    print("残高: ", Int(data[10]) + Int(data[11]) << 8)
                    
                    print("連番: ", Int(data[12]), Int(data[13]), Int(data[14]))
                    print("リージョン: ", Int(data[15]))
                }
                
                semaphore.signal()
            }
            
        }
        
        semaphore.wait()
        return transitICCard
    }
}
