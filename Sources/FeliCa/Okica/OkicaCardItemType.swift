//
//  OkicaCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// OKICA から読み取ることができるデータの種別
public enum OkicaCardItemType: CaseIterable, FeliCaCardItemType {
    /// 取引履歴
    case transactions
    /// 改札入出場履歴情報
    case entryExitInformations
    /// SF入場情報
    case sfEntryInformations
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x028F:
            self = .transactions
        case 0x050F:
            self = .entryExitInformations
        case 0x060B:
            self = .sfEntryInformations
        default:
            return nil
        }
    }
    
    public var parameter: FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .transactions:
            return (.okica, 0x028F, 20)
        case .entryExitInformations:
            return (.okica, 0x050F, 3)
        case .sfEntryInformations:
            return (.okica, 0x060B, 2)
        }
    }
    
    @available(*, unavailable, renamed: "parameter.serviceCode")
    public var serviceCode: FeliCaServiceCode {
        switch self {
        case .transactions:
            return 0x028F
        case .entryExitInformations:
            return 0x050F
        case .sfEntryInformations:
            return 0x060B
        }
    }
    
    @available(*, unavailable)
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

/// OKICA から読み取る事ができる OKICA 利用履歴のデータの種別
public enum OkicaCardTransactionType: String, Codable {
    /// 新規発行
    case newIssue
    /// ポイントチャージ
    case pointExchange
}
