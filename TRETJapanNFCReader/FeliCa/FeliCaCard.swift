//
//  FeliCaCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import CoreNFC

/// FeliCaカード
@available(iOS 13.0, *)
public protocol FeliCaCard {
    var tag: NFCFeliCaTag { get }
    
}

public protocol FeliCaCardData: Codable {
    var type: FeliCaCardType { get }
    
    var idm: String { get }
    var systemCode: FeliCaSystemCode { get }
}

public protocol FeliCaCardItem {
    
}

public enum FeliCaSystemCode: String, Codable {
    case japanRailwayCybernetics
    case common
    
    public init?(from systemCodeData: Data) {
        let systemCode = systemCodeData.map { String(format: "%.2hhx", $0) }.joined()
        switch systemCode {
        case "0003":
            self = .japanRailwayCybernetics
        case "fe00":
            self = .common
        default:
            return nil
        }
    }
    
    public var string: String {
        switch self {
        case .japanRailwayCybernetics:
            return "0003"
        case .common:
            return "fe00"
        }
    }
}

public enum FeliCaCardType: String, Codable {
    
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
    
    
    case unknown
}
