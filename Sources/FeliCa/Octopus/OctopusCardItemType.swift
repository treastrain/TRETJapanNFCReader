//
//  OctopusCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// Types of data that can be read from Octopus card
public enum OctopusCardItemType: CaseIterable, FeliCaCardItemType {
    /// Card Balance
    case balance
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x0117:
            self = .balance
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x0117
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        }
    }
}
