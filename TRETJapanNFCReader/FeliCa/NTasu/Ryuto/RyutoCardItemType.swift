//
//  RyutoCardItemType.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// りゅーと から読み取ることができるデータの種別
public enum RyutoCardItemType: CaseIterable, FeliCaCardItemType {
    /// 取引履歴
    case transactions
    /// 改札入出場履歴情報
    case entryExitInformations
    /// SF入場情報
    case sfEntryInformations
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x898F:
            self = .transactions
        case 0x884B:
            self = .entryExitInformations
        case 0x804B:
            self = .sfEntryInformations
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .transactions:
            return 0x898F
        case .entryExitInformations:
            return 0x884B
        case .sfEntryInformations:
            return 0x804B
        }
    }
    
    var blocks: Int {
        switch self {
        case .transactions:
            return 20
        case .entryExitInformations:
            return 3
        case .sfEntryInformations:
            return 2
        }
    }
}
