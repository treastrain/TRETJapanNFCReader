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
    /// 改札入出場履歴情報
    case entryExitInformations
    /// SF入場情報
    case sfEntryInformations
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x008B:
            self = .balance
        case 0x090F:
            self = .transactions
        case 0x108F:
            self = .entryExitInformations
        case 0x10CB:
            self = .sfEntryInformations
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x008B
        case .transactions:
            return 0x090F
        case .entryExitInformations:
            return 0x108F
        case .sfEntryInformations:
            return 0x10CB
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .transactions:
            return 20
        case .entryExitInformations:
            return 3
        case .sfEntryInformations:
            return 2
        }
    }
}
