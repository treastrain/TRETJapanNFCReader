//
//  DriversLicenseReaderExtensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation

@available(iOS 13.0, *)
extension DriversLicenseReader {
    
    public func convertPINStringToJISX0201(_ pinString: String) -> [UInt8]? {
        if pinString == "" {
            return [0x2A, 0x2A, 0x2A, 0x2A]
        }
        
        if pinString.count != 4 {
            return nil
        }
        
        let pinStringArray = Array(pinString)
        
        let pinSet = Set(pinStringArray)
        let enterableNumberSet: Set<String.Element> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*"]
        if !pinSet.isSubset(of: enterableNumberSet) {
            return nil
        }
        
        let pin = pinStringArray.map { (c) -> UInt8 in
            encodeToJISX0201(c)
        }
        
        return pin
    }
    
    private func encodeToJISX0201(_ c: Character) -> UInt8 {
        switch c {
        case "0":
            return 0x30
        case "1":
            return 0x31
        case "2":
            return 0x32
        case "3":
            return 0x33
        case "4":
            return 0x34
        case "5":
            return 0x35
        case "6":
            return 0x36
        case "7":
            return 0x37
        case "8":
            return 0x38
        case "9":
            return 0x39
        case "*":
            return 0x2A
        default:
            fatalError()
        }
    }
    
    internal func printData(_ responseData: Data, isPrintData: Bool = false, _ sw1: UInt8, _ sw2: UInt8) {
        let responseData = [UInt8](responseData)
        let responseString = responseData.map({ (byte) -> String in
            return byte.toHexString()
        })
        
        /*
        if isPrintData {
            print("responseCount: \(responseString.count), response: \(responseString), sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString()), ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
        } else {
            print("responseCount: \(responseString.count), sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString()), ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
        }
        */
    }
}

#endif
