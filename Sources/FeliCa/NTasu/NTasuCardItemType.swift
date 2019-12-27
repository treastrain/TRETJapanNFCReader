//
//  NTasuCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import TRETJapanNFCReader_FeliCa

/// エヌタスカードから読み取ることができるデータの種別
public enum NTasuCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// 利用履歴
    case transactions
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x408B:
            self = .balance
        case 0x80CF:
            self = .transactions
        default:
            return nil
        }
    }
    
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x408B
        case .transactions:
            return 0x80CF
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 8
        case .transactions:
            return 20
        }
    }
}
