//
//  WaonReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension WaonReader {
    
    public func readBalance(_ session: NFCTagReaderSession, _ waonCard: WaonCard) -> WaonCard {
        let semaphore = DispatchSemaphore(value: 0)
        var waonCard = waonCard
        let tag = waonCard.tag
        
        let serviceCode = Data([0x68, 0x17].reversed())
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
            
            for (i, data) in data.enumerated() {
                print(i, data)
            }
            
            let balance = data.toIntReversed(0, 2)
            waonCard.data.balance = balance
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return waonCard
    }
}
