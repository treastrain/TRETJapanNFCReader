//
//  TransitICCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from Transit IC Cards.
public enum TransitICCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    /// Transactions
    case transactions
    /// Entry and exit informations
    case entryExitInformations
    /// SF entry informations
    case sfEntryInformations
    
    /// SAPICA points
    case sapicaPoints
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x008B:
            self = .balance
        case 0x090F:
            self = .transactions
        case 0x108F:
            self = .entryExitInformations
        case 0x10CB:
            self = .sfEntryInformations
        case 0xBA4B:
            self = .sapicaPoints
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        return parameter(systemCode: .cjrc)
    }
    
    public func parameter(systemCode: FeliCaSystemCode = .cjrc) -> FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (systemCode, 0x008B, 1)
        case .transactions:
            return (systemCode, 0x090F, 20)
        case .entryExitInformations:
            return (systemCode, 0x108F, 3)
        case .sfEntryInformations:
            return (systemCode, 0x10CB, 2)
        case .sapicaPoints:
            return (.sapica, 0xBA4B, 1)
        }
    }
}
