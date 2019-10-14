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
    
    /// FeliCa エリア属性 または FeliCa サービス属性
    var attribute: FeliCaAttribute {
        let s = self & 0x3F
        switch s {
        case 0b000000:
            return .areaThatCanCreateSubArea
        case 0b000001:
            return .areaThatCannotCreateSubArea
        case 0b001000:
            return .randomServiceReadWrite
        case 0b001001:
            return .randomServiceReadWrite
        case 0b001010:
            return .randomServiceReadOnly
        case 0b001011:
            return .randomServiceReadOnly
        case 0b001100:
            return .cyclicServiceReadWrite
        case 0b001101:
            return .cyclicServiceReadWrite
        case 0b001110:
            return .cyclicServiceReadOnly
        case 0b001111:
            return .cyclicServiceReadOnly
        case 0b010000:
            return .purseServiceDirect
        case 0b010001:
            return .purseServiceDirect
        case 0b010010:
            return .purseServiceCashbackDecrement
        case 0b010011:
            return .purseServiceCashbackDecrement
        case 0b010100:
            return .purseServiceDecrement
        case 0b010101:
            return .purseServiceDecrement
        case 0b010110:
            return .purseServiceReadOnly
        case 0b010111:
            return .purseServiceReadOnly
        default:
            return .unknown
        }
    }
    
    /// 認証が必要か
    var isAuthenticationRequired: Bool {
        if self.attribute == .areaThatCanCreateSubArea || self.attribute == .areaThatCannotCreateSubArea {
            return false
        }
        
        if self & 1 == 0 {
            return true
        } else {
            return false
        }
    }
}
