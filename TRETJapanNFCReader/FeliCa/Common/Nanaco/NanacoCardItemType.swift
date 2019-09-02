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
    /// nanaco番号
    case nanacoNumber
    /// 利用履歴
    case transactions
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x5597:
            self = .balance
        case 0x558B:
            self = .nanacoNumber
        case 0x564F:
            self = .transactions
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x5597
        case .nanacoNumber:
            return 0x558B
        case .transactions:
            return 0x564F
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .nanacoNumber:
            return 1
        case .transactions:
            return 5
        }
    }
}
