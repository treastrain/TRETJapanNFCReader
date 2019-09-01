//
//  UnivCoopICPrepaidItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 大学生協ICプリペイドカードから読み取ることができるデータの種別
public enum UnivCoopICPrepaidItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// 大学生協
    case univCoopInfo
    /// 利用履歴
    case transactions
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
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
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x50D7
        case .univCoopInfo:
            return 0x50CB
        case .transactions:
            return 0x50CF
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .univCoopInfo:
            return 6
        case .transactions:
            return 10
        }
    }
}
