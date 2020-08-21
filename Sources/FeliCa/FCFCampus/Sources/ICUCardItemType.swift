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

/// Types of item data that can be read from ICU Student ID card.
public enum ICUCardItemType: CaseIterable, FeliCaCardItemType {
    /// Identity
    case identity
    /// Transactions
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
            return .init(systemCode: .common, serviceCode: 0x1A8B, numberOfBlock: 2)
        case .transactions:
            return .init(systemCode: .common, serviceCode: 0x120F, numberOfBlock: 10)
        }
    }
}
