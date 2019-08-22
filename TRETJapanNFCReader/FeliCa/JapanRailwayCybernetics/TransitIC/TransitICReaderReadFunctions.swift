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
    
    public func readBalance(_ session: NFCTagReaderSession, _ transitICCard: TransitICCard) -> TransitICCard {
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
                
                semaphore.signal()
            }
            
        }
        
        semaphore.wait()
        return transitICCard
    }
}
