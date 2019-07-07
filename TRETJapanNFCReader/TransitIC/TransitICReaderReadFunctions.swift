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
        
        tag.polling(systemCode: tag.currentSystemCode, requestCode: .systemCode, timeSlot: .max16) { (pmm, requestData, error) in
            let pmm = pmm.map { String(format: "%.2hhx", $0) }.joined()
            let requestData = requestData.map { String(format: "%.2hhx", $0) }.joined()
            print(pmm, requestData, error)
            
            let serviceCodeList: [Data] = [
                UInt16(0x008B).data
            ]
            let blockList: [Data] = [
//                UInt16(0x00).data
            ]
            tag.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (status1, status2, blockData, error) in
                if let error = error {
                    print(error)
                } else {
                    print("status1:", UInt8(status1).toHexString(), "status2:", UInt8(status2).toHexString(), blockData)
                }
                
                semaphore.signal()
            }
//            tag.requestService(nodeCodeList: serviceCodeList) { (nodeKeyVersionList, error) in
//                // print(nodeKeyVersionList, error)
//                if nodeKeyVersionList.count > 1 {
//                    let data1 = nodeKeyVersionList[0].map { String(format: "%.2hhx", $0) }.joined()
//                    print("data1: \(data1)", " ", terminator: "")
//                }
//                if nodeKeyVersionList.count > 2 {
//                    let data2 = nodeKeyVersionList[1].map { String(format: "%.2hhx", $0) }.joined()
//                    print("data2: \(data2)", " ", terminator: "")
//                }
//                print(error)
                
//                let blockList: [Data] = [
//                    UInt16(0x00).data
//                ]
                tag.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (status1, status2, blockData, error) in
                    if let error = error {
                        print(error)
                    } else {
                        print("status1:", UInt8(status1).toHexString(), "status2:", UInt8(status2).toHexString(), blockData)
                    }
                    
                    semaphore.signal()
                }
//            }
        }
        
        semaphore.wait()
        return transitICCard
    }
    
}
