//
//  RakutenEdyCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from Rakuten Edy cards.
public enum RakutenEdyCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    /// Edy Number
    case edyNumber
    /// Transactions
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x1317:
            self = .balance
        case 0x110B:
            self = .edyNumber
        case 0x170F:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return .init(systemCode: .common, serviceCode: 0x1317, numberOfBlock: 1)
        case .edyNumber:
            return .init(systemCode: .common, serviceCode: 0x110B, numberOfBlock: 1)
        case .transactions:
            return .init(systemCode: .common, serviceCode: 0x170F, numberOfBlock: 6)
        }
    }
}
