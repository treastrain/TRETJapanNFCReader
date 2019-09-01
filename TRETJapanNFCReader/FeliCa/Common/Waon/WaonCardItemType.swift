//
//  WaonCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// WAONカードから読み取る事ができるデータの種別
public enum WaonCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// WAON番号
    case waonNumber
    /// ポイント
    case points
    /// 利用履歴
    case transactions
    
    
    internal init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x6817:
            self = .balance
        case 0x684F:
            self = .waonNumber
        case 0x684B:
            self = .points
        case 0x680B:
            self = .transactions
        default:
            return nil
        }
    }
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x6817
        case .waonNumber:
            return 0x684F
        case .points:
            return 0x684B
        case .transactions:
            return 0x680B
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        case .waonNumber:
            return 1
        case .points:
            return 1
        case .transactions:
            return 9
        }
    }
}
