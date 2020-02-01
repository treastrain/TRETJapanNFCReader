//
//  ICUCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

// data typs which can be obtained from ICU Student ID card.
public enum ICUCardItemType: CaseIterable, FeliCaCardItemType {
    case identity
    case transactions
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x1A8B:
            self = .identity
        case 0x120F:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .identity:
            return (.common, 0x1A8B, 2)
        case .transactions:
            return (.common, 0x120F, 10)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        self.parameter.serviceCode
    }
    
    @available(*, unavailable)
    var blocks: Int {
        switch self {
        case .identity:
            return 2
        case .transactions:
            return 10
        }
    }
}
