//
//  TransitICCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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
    
    /// SAPICA ポイント
    case sapicaPoints
    
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x008B:
            self = .balance
        case 0x090F:
            self = .transactions
        case 0x108F:
            self = .entryExitInformations
        case 0x10CB:
            self = .sfEntryInformations
        case 0xBA4B:
            self = .sapicaPoints
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        return parameter(systemCode: .cjrc)
    }
    
    public func parameter(systemCode: FeliCaSystemCode = .cjrc) -> FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .balance:
            return (systemCode, 0x008B, 1)
        case .transactions:
            return (systemCode, 0x090F, 20)
        case .entryExitInformations:
            return (systemCode, 0x108F, 3)
        case .sfEntryInformations:
            return (systemCode, 0x10CB, 2)
        case .sapicaPoints:
            return (.sapica, 0xBA4B, 1)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x008B
        case .transactions:
            return 0x090F
        case .entryExitInformations:
            return 0x108F
        case .sfEntryInformations:
            return 0x10CB
        case .sapicaPoints:
            return 0xBA4B
        }
    }
    
    @available(*, unavailable)
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
        case .sapicaPoints:
            return 1
        }
    }
}
