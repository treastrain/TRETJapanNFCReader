//
//  FeliCaSystemCode.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

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
    
    case fcfcampus
    
    case octopus
    
    case common
    
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
        case "8760":
            self = .fcfcampus
        case "8008":
            self = .octopus
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
        case .fcfcampus:
            return "8760"
        case .octopus:
            return "8008"
        case .common:
            return "fe00"
        }
    }
}
