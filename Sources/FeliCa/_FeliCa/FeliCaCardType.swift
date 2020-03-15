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
    /// 地方交通系ICカード（passca、ecomyca、りゅーと）
    case localTransitIC
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
    
    /// FCF Campus Card
    case fcfcampus
    
    /// Octopus Card (八達通)
    case octopus
    
    /// iD （PKPaymentNetwork に準拠し、`idCredit` とした）
    case idCredit
    /// QUICPay
    case quicPay
    
    case unknown
    
//    public init?(rawValue: String) {
//        print(rawValue)
//        RawRepresentable
//        self.init(rawValue: rawValue)
//    }
    
    public var localizedString: String {
        switch self {
        case .transitIC:
            return Localized.transitIC.string()
        case .localTransitIC:
            return "地方交通系IC"
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
    
    /// りゅーと
    // case ryuto
    
    public init(rawValue: String) {
        switch rawValue {
        case "transitIC":
            self = .transitIC
        case "localTransitIC", "ryuto":
            self = .localTransitIC
        case "rakutenEdy":
            self = .rakutenEdy
        case "nanaco":
            self = .nanaco
        case "waon":
            self = .waon
        case "univCoopICPrepaid":
            self = .univCoopICPrepaid
        case "okica":
            self = .okica
        case "ntasu":
            self = .ntasu
        case "fcfcampus":
            self = .fcfcampus
        case "octopus":
            self = .octopus
        case "idCredit":
            self = .idCredit
        case "quicPay":
            self = .quicPay
        default:
            self = .unknown
        }
    }
}
