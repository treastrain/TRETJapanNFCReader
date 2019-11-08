//
//  FeliCaCardType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

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
    
    /// FCF Campus Card
    case fcfcampus
    
    /// Octopus Card (八達通)
    case octopus
    
    case unknown
    
    public var localizedString: String {
        switch self {
        case .transitIC:
            return String(format: NSLocalizedString("transitIC", bundle: Bundle.current, comment: ""))
        case .rakutenEdy:
            return String(format: NSLocalizedString("rakutenEdy", bundle: Bundle.current, comment: ""))
        case .nanaco:
            return String(format: NSLocalizedString("nanaco", bundle: Bundle.current, comment: ""))
        case .waon:
            return String(format: NSLocalizedString("waon", bundle: Bundle.current, comment: ""))
        case .univCoopICPrepaid:
            return String(format: NSLocalizedString("univCoopICPrepaid", bundle: Bundle.current, comment: ""))
        case .okica:
            return "OKICA"
        case .fcfcampus:
            return "FCF Campus"
        case .octopus:
            return "Octopus (八達通)"
        case .ntasu:
            return "エヌタス"
        case .unknown:
            return "Unknown"
        }
    }
}
