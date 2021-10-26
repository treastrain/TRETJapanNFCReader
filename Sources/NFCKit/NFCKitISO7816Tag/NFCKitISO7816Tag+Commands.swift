//
//  NFCKitISO7816Tag+Commands.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/21.
//

import NFCKitCore

#if canImport(CoreNFC)
@available(iOS 13.0, *)
extension CoreNFC.NFCISO7816Tag {
    
    // MARK: - eraseBinary
    
    // MARK: - verify
    public func verify(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x20, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    // MARK: - manageChannel
    
    // MARK: - externalAuthenticate
    
    // MARK: - getChallenge
    
    // MARK: - internalAuthenticate
    
    // MARK: - selectFile
    public func selectFile(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    // MARK: - readBinary
    
    // MARK: - readRecords
    
    // MARK: - getResponse
    
    // MARK: - envelope
    
    // MARK: - getData
    
    // MARK: - writeBinary
    
    // MARK: - writeRecord
    
    // MARK: - updateBinary
    
    // MARK: - putData
    
    // MARK: - updateData
    
    // MARK: - appendRecord
    
}
#endif

