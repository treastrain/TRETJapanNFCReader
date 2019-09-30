//
//  FeliCaCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

#if os(iOS)
/// FeliCaカード
@available(iOS 13.0, *)
public protocol FeliCaCard {
    var tag: NFCFeliCaTag { get }
}
#endif

public protocol FeliCaCardData: Codable {
    var type: FeliCaCardType { get }
    var idm: String { get }
    var systemCode: FeliCaSystemCode { get }
    var data: [FeliCaServiceCode : [Data]] { get }
    
    mutating func convert()
    func toJSONData() -> Data?
}

extension FeliCaCardData {
    public func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

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
    
    /// Octopus Card (八達通)
    case octopus

    /// FCF Campus Card
    case fcfcampus
    
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
        case .octopus:
            return "Octopus (八達通)"
        case .fcfcampus:
            return "FCF Campus"
        case .unknown:
            return "Unknown"
        }
    }
}

public enum FeliCaSystemCode: String, Codable, CaseIterable {
    case japanRailwayCybernetics
    case iruca
    case paspy
    case sapica
    
    case okikca
    // case ica
    // case luluca
    // case nicepass
    // case cica
    
    case common
    
    case octopus

    case fcfcampus
    
    public init?(from systemCodeData: Data) {
        let systemCode = systemCodeData.map { String(format: "%.2hhx", $0) }.joined()
        switch systemCode {
        case "0003":
            self = .japanRailwayCybernetics
        case "80de":
            self = .iruca
        case "8592":
            self = .paspy
        case "865e":
            self = .sapica
        case "8fc1":
            self = .okikca
//        case "80ef":
//            self = .ica
//        case "a604":
//            self = .luluca
//        case "0f04":
//            self = .nicepass
//        case "8157":
//            self = .cica
        case "fe00":
            self = .common
        case "8008":
            self = .octopus
        case "8760":
            self = .fcfcampus
        default:
            return nil
        }
    }
    
    public var string: String {
        switch self {
        case .japanRailwayCybernetics:
            return "0003"
        case .iruca:
            return "80de"
        case .paspy:
            return "8592"
        case .sapica:
            return "865e"
        case .okikca:
            return "8fc1"
//        case .ica:
//            return "80ef"
//        case .luluca:
//            return "a604"
//        case .nicepass:
//            return "0f04"
//        case .cica:
//            return "8157"
        case .common:
            return "fe00"
        case .octopus:
            return "8008"
        case .fcfcampus:
            return "8760"
        }
    }
}

public typealias FeliCaServiceCode = UInt16

public protocol FeliCaCardItems: Codable {
}

public protocol FeliCaCardTransaction: Codable {
    var date: Date { get }
    var type: FeliCaCardTransactionType { get }
    var difference: Int { get }
    var balance: Int { get }
}

public enum FeliCaCardTransactionType: String, Codable {
    /// 支払い
    case purchase
    /// チャージ
    case credit
    /// 交通機関
    case transit
    
    
    /// その他
    case other
    case unknown
}

public protocol FeliCaCardItemType {
}
