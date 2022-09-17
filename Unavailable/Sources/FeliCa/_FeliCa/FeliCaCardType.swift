//
//  FeliCaCardType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

public enum FeliCaCardType: String, Codable, CaseIterable {
    /// 交通系ICカード
    case transitIC
    /// 楽天Edyカード
    case rakutenEdy
    /// nanaco
    case nanaco
    /// WAON
    case waon
    /// 大学生協ICプリペイドカード
    case univCoopICPrepaid
    
    /// OKICA
    case okica
    /// エヌタス
    case ntasu
    /// りゅーと
    case ryuto
    
    /// FCF Campus Card
    case fcfcampus
    
    /// Octopus Card (八達通)
    case octopus
    
    /// iD （PKPaymentNetwork に準拠し、`idCredit` とした）
    case idCredit
    /// QUICPay
    case quicPay
    
    case unknown
    
    public var localizedString: String {
        switch self {
        case .transitIC:
            return Localized.transitIC.string()
        case .rakutenEdy:
            return Localized.rakutenEdy.string()
        case .nanaco:
            return "nanaco"
        case .waon:
            return "WAON"
        case .univCoopICPrepaid:
            return Localized.univCoopICPrepaid.string()
        case .okica:
            return "OKICA"
        case .ntasu:
            return "NTasu"
        case .ryuto:
            return Localized.ryuto.string()
        case .fcfcampus:
            return "FCF Campus"
        case .octopus:
            return Localized.octopus.string()
        case .idCredit:
            return "iD"
        case .quicPay:
            return "QUICPay"
        case .unknown:
            return "Unknown"
        }
    }
}
