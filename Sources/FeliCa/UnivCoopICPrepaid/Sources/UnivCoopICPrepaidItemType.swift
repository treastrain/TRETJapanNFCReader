//
//  UnivCoopICPrepaidItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from Japanese Univ. Co-op IC Prepaid cards.
public enum UnivCoopICPrepaidCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    /// Univ. Co-op Info
    case univCoopInfo
    /// Transactions
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x50D7:
            self = .balance
        case 0x50CB:
            self = .univCoopInfo
        case 0x50CF:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return .init(systemCode: .common, serviceCode: 0x50D7, numberOfBlock: 1)
        case .univCoopInfo:
            return .init(systemCode: .common, serviceCode: 0x50CB, numberOfBlock: 6)
        case .transactions:
            return .init(systemCode: .common, serviceCode: 0x50CF, numberOfBlock: 10)
        }
    }
}

// 互換性維持のための typealias
public typealias UnivCoopICPrepaidItemType = UnivCoopICPrepaidCardItemType
