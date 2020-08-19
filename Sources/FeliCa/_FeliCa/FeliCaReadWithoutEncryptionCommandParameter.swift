//
//  FeliCaReadWithoutEncryptionCommandParameter.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/02.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct FeliCaReadWithoutEncryptionCommandParameter: Codable, Hashable {
    public let systemCode: FeliCaSystemCode
    public let serviceCode: FeliCaServiceCode
    public let numberOfBlock: Int
    
    public init(systemCode: FeliCaSystemCode, serviceCode: FeliCaServiceCode, numberOfBlock: Int) {
        self.systemCode = systemCode
        self.serviceCode = serviceCode
        self.numberOfBlock = numberOfBlock
    }
    
    public static func == (lhs: FeliCaReadWithoutEncryptionCommandParameter, rhs: FeliCaReadWithoutEncryptionCommandParameter) -> Bool {
        return lhs.systemCode == rhs.systemCode && lhs.serviceCode == rhs.serviceCode && lhs.numberOfBlock == rhs.numberOfBlock
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(systemCode)
        hasher.combine(serviceCode)
        hasher.combine(numberOfBlock)
    }
}
