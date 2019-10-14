//
//  FeliCaAttribute.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/14.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// FeliCa エリア属性 または FeliCa サービス属性
public enum FeliCaAttribute {
    case areaThatCanCreateSubArea
    case areaThatCannotCreateSubArea
    case randomServiceReadWrite
    case randomServiceReadOnly
    case cyclicServiceReadWrite
    case cyclicServiceReadOnly
    case purseServiceDirect
    case purseServiceCashbackDecrement
    case purseServiceDecrement
    case purseServiceReadOnly
    
    case unknown
    
    public var description: String {
        switch self {
        case .areaThatCanCreateSubArea:
            return "Area (that can create Sub-Area)"
        case .areaThatCannotCreateSubArea:
            return "Area (that cannot create Sub-Area)"
        case .randomServiceReadWrite:
            return "Random Service, Read/Write Access"
        case .randomServiceReadOnly:
            return "Random Service, Read Only Access"
        case .cyclicServiceReadWrite:
            return "Cyclic Service, Read/Write Access"
        case .cyclicServiceReadOnly:
            return "Cyclic Service, Read Only Access"
        case .purseServiceDirect:
            return "Purse Service, Direct Access"
        case .purseServiceCashbackDecrement:
            return "Purse Service, Cashback Access/Decrement Access"
        case .purseServiceDecrement:
            return "Purse Service, Decrement Access"
        case .purseServiceReadOnly:
            return "Purse Service, Read Only Access"
        case .unknown:
            return "Unknown"
        }
    }
}
