//
//  NanacoCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from nanaco cards.
public enum NanacoCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    /// nanaco Number
    case nanacoNumber
    /// Points
    case points
    /// Transactions
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x5597:
            self = .balance
        case 0x558B:
            self = .nanacoNumber
        case 0x560B:
            self = .points
        case 0x564F:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return .init(systemCode: .common, serviceCode: 0x5597, numberOfBlock: 1)
        case .nanacoNumber:
            return .init(systemCode: .common, serviceCode: 0x558B, numberOfBlock: 1)
        case .points:
            return .init(systemCode: .common, serviceCode: 0x560B, numberOfBlock: 2)
        case .transactions:
            return .init(systemCode: .common, serviceCode: 0x564F, numberOfBlock: 5)
        }
    }
}
