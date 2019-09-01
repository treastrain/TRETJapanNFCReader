//
//  RakutenEdyCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 楽天Edyカードから読み取ることができるデータの種別
public enum RakutenEdyCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// Edy番号
    case edyNumber
    /// 利用履歴
    case transactions
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
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
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x1317
        case .edyNumber:
            return 0x110B
        case .transactions:
            return 0x170F
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .edyNumber:
            return 1
        case .transactions:
            return 6
        }
    }
}
