//
//  IndividualNumberReaderCommands.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
extension IndividualNumberReader {
    
    typealias IndividualNumberReaderCompletionHandler = (_ responseData: Data, _ sw1: UInt8, _ sw2: UInt8, _ error: Error?) -> Void
    
    internal func selectDF(tag: IndividualNumberCardTag, data: Data, completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x04, p2Parameter: 0x0C, data: data, expectedResponseLength: -1)
        
        tag.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    internal func selectEF(tag: IndividualNumberCardTag, data: [UInt8], completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: 0x02, p2Parameter: 0x0C, data: Data(data), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func verify(tag: IndividualNumberCardTag, pin: [UInt8], completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x20, p1Parameter: 0x00, p2Parameter: 0x80, data: Data(pin), expectedResponseLength: -1)
        
        tag.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    internal func readBinary(tag: IndividualNumberCardTag, p1Parameter: UInt8, p2Parameter: UInt8, expectedResponseLength: Int, completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let adpu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xB0, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: Data([]), expectedResponseLength: expectedResponseLength)
        
        tag.sendCommand(apdu: adpu, completionHandler: completionHandler)
    }
    
    internal func selectJPKIAP(tag: IndividualNumberCardTag, completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let data = IndividualNumberCardAID.jpkiAP
        self.selectDF(tag: tag, data: data, completionHandler: completionHandler)
    }
    
    internal func selectCardInfoInputSupportAP(tag: IndividualNumberCardTag, completionHandler: @escaping IndividualNumberReaderCompletionHandler) {
        let data = IndividualNumberCardAID.cardInfoInputSupportAP
        self.selectDF(tag: tag, data: data, completionHandler: completionHandler)
    }
}

internal enum IndividualNumberCardAID {
    internal static var jpkiAP = Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
    internal static var cardInfoInputSupportAP = Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x04, 0x08])
    internal static var individualNumberAP = Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x01, 0x00])
}


#endif
