//
//  TransitICCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 交通系ICカードから読み取ることができるデータの種別
public enum TransitICCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// 取引履歴
    case transactions
    
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x008B
        case .transactions:
            return 0x090F
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .transactions:
            return 20
        }
    }
}
