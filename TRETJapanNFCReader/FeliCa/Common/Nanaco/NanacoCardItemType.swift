//
//  NanacoCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// nanacoカードから読み取ることができるデータの種別
public enum NanacoCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x5597:
            self = .balance
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x5597
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        }
    }
}
