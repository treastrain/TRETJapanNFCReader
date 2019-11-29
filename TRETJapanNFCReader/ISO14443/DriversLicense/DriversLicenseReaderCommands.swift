//
//  DriversLicenseReaderCommands.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/30.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
extension DriversLicenseReader {
    
    /// オペレーションが完了した後にセッションが呼び出す handler。
    /// - Parameter responseData: レスポンスデータ。オペレーションが正常に完了したときでも空である場合がある。
    /// - Parameter sw1: ステータスバイト1。
    /// - Parameter sw2: ステータスバイト2。
    /// - Parameter error: オペレーションが正常に完了した場合はnil。 運転免許証との通信に問題があるときはNSError。
    typealias DriversLicenseReaderCompletionHandler = (_ responseData: Data, _ sw1: UInt8, _ sw2: UInt8, _ error: Error?) -> Void
    
    internal func selectMF(tag: DriversLicenseCardTag, completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x00, p2Parameter: 0x00, data: Data([]), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func selectDF1(tag: DriversLicenseCardTag, completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x0C, data: Data([0xA0, 0x00, 0x00, 0x02, 0x31, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func selectDF2(tag: DriversLicenseCardTag, completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x0C, data: Data([0xA0, 0x00, 0x00, 0x02, 0x31, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func selectEF(tag: DriversLicenseCardTag, data: [UInt8], completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x02, p2Parameter: 0x0C, data: Data(data), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func verify(tag: DriversLicenseCardTag, pin: [UInt8], completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x20, p1Parameter: 0x00, p2Parameter: 0x80, data: Data(pin), expectedResponseLength: -1)
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func readBinary(tag: DriversLicenseCardTag, p1Parameter: UInt8, p2Parameter: UInt8, expectedResponseLength: Int, completionHandler: @escaping DriversLicenseReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xB0, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: Data([]), expectedResponseLength: expectedResponseLength)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
}

#endif
