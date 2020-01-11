//
//  NTasuCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (.ntasu, 0x408B, 8)
        case .transactions:
            return (.ntasu, 0x80CF, 20)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x408B
        case .transactions:
            return 0x80CF
        }
    }
    
    @available(*, unavailable)
    var blocks: Int {
        switch self {
        case .balance:
            return 8
        case .transactions:
            return 20
        }
    }
}
