//
//  IndividualNumberReaderStatus.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum IndividualNumberReaderStatus: String {
    case x9000 // "正常終了"
    
    init(sw1: UInt8, sw2: UInt8) {
        var sw1 = String(sw1, radix: 16).uppercased()
        var sw2 = String(sw2, radix: 16).uppercased()
        if sw1 == "0" {
            sw1 = "00"
        }
        if sw2 == "0" {
            sw2 = "00"
        }
        let rawValue = "x" + sw1 + sw2
        self = IndividualNumberReaderStatus(rawValue: rawValue)!
    }
    
    public var description: String {
        switch self {
        case .x9000:
            return "正常終了"
        }
    }
}
