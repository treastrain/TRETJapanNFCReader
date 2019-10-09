//
//  FeliCaServiceCode.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public typealias FeliCaServiceCode = UInt16

public extension FeliCaServiceCode {
    
    var attribute: String {
        let s = (self >> 1) & 0x1F
        switch s {
        case 0b00000:
            return "Area"
        case 0b00100:
            return "Random Service, Read/Write Access"
        case 0b00101:
            return "Random Service, Read Only Access"
        case 0b00110:
            return "Cyclic Service, Read/Write Access"
        case 0b00111:
            return "Cyclic Service, Read Only Access"
        case 0b01000:
            return "Purse Service, Direct Access"
        case 0b01001:
            return "Purse Service, Cashback Access/Decrement Access"
        case 0b01010:
            return "Purse Service, Decrement Access"
        case 0b01011:
            return "Purse Service, Read Only Access"
        default:
            return "Unknown"
        }
    }
}
