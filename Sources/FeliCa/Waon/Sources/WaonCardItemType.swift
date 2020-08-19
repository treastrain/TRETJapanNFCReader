//
//  WaonCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from WAON cards.
public enum WaonCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    /// WAON Number
    case waonNumber
    /// Points
    case points
    /// Transactions
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x6817:
            self = .balance
        case 0x684F:
            self = .waonNumber
        case 0x684B:
            self = .points
        case 0x680B:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return .init(systemCode: .common, serviceCode: 0x6817, numberOfBlock: 1)
        case .waonNumber:
            return .init(systemCode: .common, serviceCode: 0x684F, numberOfBlock: 1)
        case .points:
            return .init(systemCode: .common, serviceCode: 0x684B, numberOfBlock: 1)
        case .transactions:
            return .init(systemCode: .common, serviceCode: 0x680B, numberOfBlock: 9)
        }
    }
}
