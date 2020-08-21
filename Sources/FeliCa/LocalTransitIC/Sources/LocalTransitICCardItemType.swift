//
//  LocalTransitICCardItemType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// Types of item data that can be read from Local Transit IC Cards.
public enum LocalTransitICCardItemType: CaseIterable, FeliCaCardItemType {
    /// Transactions
    case transactions
    
    public init?(_ serviceCode: FeliCaServiceCode) {
        switch serviceCode {
        case 0x898F:
            self = .transactions
        case 0x884B:
            // self = .balance
            fallthrough
        case 0x804B:
            // self = .issuerInfo
            fallthrough
        default:
            return nil
        }
    }
    
    public func parameter(systemCode: FeliCaSystemCode) -> FeliCaReadWithoutEncryptionCommandParameter {
        switch self {
        case .transactions:
            return .init(systemCode: systemCode, serviceCode: 0x898F, numberOfBlock: 20)
        // case .balance:
        //     return .init(systemCode: systemCode, serviceCode: 0x884B, numberOfBlock: 3)
        // case .issuerInfo:
        //     return .init(systemCode: systemCode, serviceCode: 0x804B, numberOfBlock: 2)
        }
    }
}

@available(*, unavailable, renamed: "LocalTransitICCardItemType")
public typealias RyutoCardItemType = LocalTransitICCardItemType
