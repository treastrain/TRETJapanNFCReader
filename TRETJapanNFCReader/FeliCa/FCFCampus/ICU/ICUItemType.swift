//
//  ICUItemType.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

// data typs which can be obtained from ICU Student ID card.
public enum ICUItemType: CaseIterable, FeliCaCardItemType {
    case identity = 0x188B
    case transactions = 0x120F
    
    // typeof FeliCaServiceCode == UInt16
    internal init?(_ serviceCode: FeliCaServiceCode) {
        let service = ICUItemType(rawValue: serviceCode)
        switch service {
        case .Some:
            self = service!
        case .None {
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
       self.rawValue
    }
    
    var blocks: Int {
        switch self {
        case .identity:
            return 2
        case .transactions:
            return 10
        }
    }
}
