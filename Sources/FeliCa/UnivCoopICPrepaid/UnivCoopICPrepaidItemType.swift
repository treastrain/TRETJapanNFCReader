//
//  UnivCoopICPrepaidItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 大学生協ICプリペイドカードから読み取ることができるデータの種別
public enum UnivCoopICPrepaidItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// 大学生協
    case univCoopInfo
    /// 利用履歴
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
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
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (.common, 0x50D7, 1)
        case .univCoopInfo:
            return (.common, 0x50CB, 6)
        case .transactions:
            return (.common, 0x50CF, 10)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x50D7
        case .univCoopInfo:
            return 0x50CB
        case .transactions:
            return 0x50CF
        }
    }
    
    @available(*, unavailable)
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
