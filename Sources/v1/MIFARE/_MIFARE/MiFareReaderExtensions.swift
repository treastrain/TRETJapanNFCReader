//
//  MiFareReaderExtensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation

@available(iOS 13.0, *)
extension MiFareReader {
    
    public func printData(_ responseData: Data, isPrintData: Bool = false, _ sw1: UInt8, _ sw2: UInt8) {
        let responseData = [UInt8](responseData)
        let responseString = responseData.map({ (byte) -> String in
            return byte.toHexString()
        })
        
        if isPrintData {
            print("responseCount: \(responseString.count), response: \(responseString), sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString()), ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
        } else {
            print("responseCount: \(responseString.count), sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString()), ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
        }
    }
}

#endif
