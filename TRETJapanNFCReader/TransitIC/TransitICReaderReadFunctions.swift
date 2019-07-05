//
//  TransitICReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

extension TransitICReader {
    
    internal func readBalance(_ session: NFCTagReaderSession, _ transitICCard: TransitICCard) -> TransitICCard {
        let semaphore = DispatchSemaphore(value: 0)
        var transitICCard = transitICCard
        let tag = transitICCard.tag
        
        let serviceCodeList: [Data] = [
            UInt16(0x090F).data
        ]
        tag.polling(systemCode: tag.currentSystemCode, requestCode: .systemCode, timeSlot: .max16) { (pmm, requestData, error) in
            let pmm = pmm.map { String(format: "%.2hhx", $0) }.joined()
            let requestData = requestData.map { String(format: "%.2hhx", $0) }.joined()
            print(pmm, requestData, error)
            
            tag.requestService(nodeCodeList: serviceCodeList) { (nodeKeyVersionList, error) in
                print(nodeKeyVersionList, error)
                
                let blockList: [Data] = [
                    UInt16(0x10).data,
                    UInt16(0x11).data
                ]
                tag.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (status1, status2, blockData, error) in
                    print(status1, status2, blockData, error)
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return transitICCard
    }
    
}
