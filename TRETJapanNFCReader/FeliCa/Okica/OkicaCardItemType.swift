//
//  OkicaCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

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
