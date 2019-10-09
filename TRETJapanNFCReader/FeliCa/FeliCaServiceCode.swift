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
    
    var isAuthenticationRequired: Bool {
        if self & 0x3F == 0b000000 {
            return false
        }
        
        if self & 1 == 0 {
            return true
        } else {
            return false
        }
    }
    
    var attribute: String {
        let s = self & 0x3F
        switch s {
        case 0b000000:
            return "Area"
        case 0b001000:
            return "Random Service, Read/Write Access: authentication required"
        case 0b001001:
            return "Random Service, Read/Write Access: authentication not required"
        case 0b001010:
            return "Random Service, Read Only Access: authentication required"
        case 0b001011:
            return "Random Service, Read Only Access: authentication not required"
        case 0b001100:
            return "Cyclic Service, Read/Write Access: authentication required"
        case 0b001101:
            return "Cyclic Service, Read/Write Access: authentication not required"
        case 0b001110:
            return "Cyclic Service, Read Only Access: authentication required"
        case 0b001111:
            return "Cyclic Service, Read Only Access: authentication not required"
        case 0b010000:
            return "Purse Service, Direct Access: authentication required"
        case 0b010001:
            return "Purse Service, Direct Access: authentication not required"
        case 0b010010:
            return "Purse Service, Cashback Access/Decrement Access: authentication required"
        case 0b010011:
            return "Purse Service, Cashback Access/Decrement Access: authentication not required"
        case 0b010100:
            return "Purse Service, Decrement Access: authentication required"
        case 0b010101:
            return "Purse Service, Decrement Access: authentication not required"
        case 0b010110:
            return "Purse Service, Read Only Access: authentication required"
        case 0b010111:
            return "Purse Service, Read Only Access: authentication not required"
        default:
            return "Unknown"
        }
    }
}
