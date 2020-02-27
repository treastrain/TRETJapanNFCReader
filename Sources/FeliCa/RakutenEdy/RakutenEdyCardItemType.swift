//
//  RakutenEdyCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 楽天Edyカードから読み取ることができるデータの種別
public enum RakutenEdyCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    /// Edy番号
    case edyNumber
    /// 利用履歴
    case transactions
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
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
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (.common, 0x1317, 1)
        case .edyNumber:
            return (.common, 0x110B, 1)
        case .transactions:
            return (.common, 0x170F, 6)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x1317
        case .edyNumber:
            return 0x110B
        case .transactions:
            return 0x170F
        }
    }
    
    @available(*, unavailable)
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
