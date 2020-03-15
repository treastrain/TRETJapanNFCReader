//
//  LocalTransitICCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 地方交通系ICカードから読み取ることができるデータの種別
public enum LocalTransitICCardItemType: CaseIterable, FeliCaCardItemType {
    /// 取引履歴
    case transactions
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x898F:
            self = .transactions
        case 0x884B:
            fallthrough
        case 0x804B:
            fallthrough
        default:
            return nil
        }
    }
    
    public func parameter(systemCode: FeliCaSystemCode) -> FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .transactions:
            return (systemCode, 0x898F, 20)
        }
    }
}

@available(*, unavailable, renamed: "LocalTransitICCardItemType")
public enum RyutoCardItemType: CaseIterable, FeliCaCardItemType {}
