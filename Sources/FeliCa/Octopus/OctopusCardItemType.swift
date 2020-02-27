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

/// Types of data that can be read from Octopus card
public enum OctopusCardItemType: CaseIterable, FeliCaCardItemType {
    /// Card Balance
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
            return (.octopus, 0x0117, 1)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x0117
        }
    }
    
    @available(*, unavailable)
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        }
    }
}
