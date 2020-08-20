//
//  OctopusCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from Octopus cards.
public enum OctopusCardItemType: CaseIterable, FeliCaCardItemType {
    /// Balance
    case balance
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x0117:
            self = .balance
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return .init(systemCode: .octopus, serviceCode: 0x0117, numberOfBlock: 1)
        }
    }
}
