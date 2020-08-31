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
    /// 地方の交通系ICカード
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
//    /// エヌタス
//    case ntasu
    
    /// FCF Campus Card
    case fcfcampus
    
    /// Octopus Card (八達通)
    case octopus
    
//    /// iD （PKPaymentNetwork に準拠し、`idCredit` とした）
//    case idCredit
//    /// QUICPay
//    case quicPay
    
    case unknown
    
    
    public var localizedName: String {
        switch self {
        case .transitIC:
            return "Transit IC"
        case .localTransitIC:
            return "Local Transit IC"
        case .rakutenEdy:
            return "Rakuten Edy"
        case .nanaco:
            return "nanaco"
        case .waon:
            return "WAON"
        case .univCoopICPrepaid:
            return "Univ. Co-op IC Prepaid"
        case .okica:
            return "OKICA"
        case .fcfcampus:
            return "FCF Campus"
        case .octopus:
            return "Octopus"
        case .unknown:
            return "Unknown"
        }
    }
    
    /// りゅーと
    @available(*, unavailable, renamed: "localTransitIC")
    public static var ryuto = FeliCaCardType.localTransitIC
    
    @available(*, unavailable, renamed: "localizedName")
    public var localizedString: String {
        return self.localizedName
    }
}
