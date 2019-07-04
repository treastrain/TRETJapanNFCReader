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
        
        tag.polling(systemCode: tag.currentSystemCode, requestCode: .systemCode, timeSlot: .max1) { (pmm, responseData, error) in
            let pmm = pmm.map { String(format: "%.2hhx", $0) }.joined()
            let responseData = responseData.map { String(format: "%.2hhx", $0) }.joined()
            print(pmm, responseData, error)
            
            let nodeCodeList: [Data] = [
                tag.currentSystemCode,
                Data([UInt8(0x09), UInt8(0x0f)])
            ]
            tag.requestService(nodeCodeList: nodeCodeList) { (data, error) in
                if data.count > 1 {
                    let data1 = data[0].map { String(format: "%.2hhx", $0) }.joined()
                    print(data1, " ", terminator: "")
                }
                if data.count > 2 {
                    let data2 = data[1].map { String(format: "%.2hhx", $0) }.joined()
                    print(data2, " ", terminator: "")
                }
                print(error)
                
                let serviceCodeList = [
                    Data([UInt8(0x09), UInt8(0x0f)])
                ]
                
                let blockList = [
                    Data([UInt8(0x10), UInt8(0x11)])
                ]
                tag.readWithoutEncryption(serviceCodeList: serviceCodeList, blockList: blockList) { (int1, int2, dataArray, error) in
                    print(int1, int2, dataArray, error)
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return transitICCard
    }
    
}
