//
//  WaonCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
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
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (.common, 0x6817, 1)
        case .waonNumber:
            return (.common, 0x684F, 1)
        case .points:
            return (.common, 0x684B, 1)
        case .transactions:
            return (.common, 0x680B, 9)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
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
    
    @available(*, unavailable)
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
