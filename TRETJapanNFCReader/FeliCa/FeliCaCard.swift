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
    
    var idm: String { get }
    var systemCode: FeliCaSystemCode { get }
    
    func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, items: [FeliCaCardItem], completion: @escaping (FeliCaCard) -> Void)
}

public protocol FeliCaCardItem {
    
}

public enum FeliCaSystemCode {
    
    /// 交通系ICカード
    case transitIC
    /// 大学生協ICプリペイドカード
    case univCoopICPrepaid
    
    public init?(from systemCodeData: Data) {
        let systemCode = systemCodeData.map { String(format: "%.2hhx", $0) }.joined()
        switch systemCode {
        case "0003":
            self = .transitIC
        case "FE00":
            self = .univCoopICPrepaid
        default:
            return nil
        }
    }
    
    public var string: String {
        switch self {
        case .transitIC:
            return "0003"
        case .univCoopICPrepaid:
            return "FE00"
        }
    }
}
