//
//  DriversLicenseReaderCommand.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/30.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

extension DriversLicenseReader {
    
    internal func selectMF(tag: DriversLicenseCardTag, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x00, p2Parameter: 0x00, data: Data([]), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func selectEF(tag: DriversLicenseCardTag, data: [UInt8], completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x02, p2Parameter: 0x0C, data: Data(data), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func readBinary(tag: DriversLicenseCardTag, p1Parameter: UInt8, p2Parameter: UInt8, expectedResponseLength: Int, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xB0, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: Data([]), expectedResponseLength: expectedResponseLength)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func printData(_ responseData: Data, _ sw1: UInt8, _ sw2: UInt8) {
        var printString = "--------------------\nレスポンスデータ\n"
        printString += "ステータス: \(Status(sw1: sw1, sw2: sw2).description) sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString())\n"
        
        let responseData = [UInt8](responseData)
        var responseString: [String] = []
        for (i, byte) in zip(responseData.indices, responseData) {
            if i == 0 {
                printString += "T(タグ): \(byte.toHexString())\n"
                // TODO: DF2/EF01 のみ 2バイト
            } else if i == 1 {
                printString += "L(長さ): \(byte.toHexString())\n"
                // TODO: 0x82 は
            } else {
                responseString.append(byte.toHexString())
                //                responseString.append(String(bytes: [byte], encoding: String.Encoding.shiftJIS) ?? String(hexByte: byte))
            }
        }
        
        printString += "--------------------"
//        print(printString)
        
        print("responseCount: \(responseString.count), response: \(responseString), sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString()), ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
    }
    
}

