//
//  FeliCaSystem.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/09.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct FeliCaSystem: Codable {
    public let systemCode: FeliCaSystemCode
    public let idm: FeliCaIDm
    public let pmm: FeliCaPMm
    public let services: [FeliCaServiceCode : FeliCaBlockData]
    
    public subscript(serviceCode: FeliCaServiceCode) -> FeliCaBlockData? {
        return self.services[serviceCode]
    }
}

/*
public struct FeliCaSystem: Codable {
    public let systemCode: FeliCaSystemCode
    public let idm: String
    public var services: [FeliCaServiceCode : [Data]]
    
    public subscript(serviceCode: FeliCaServiceCode) -> [Data]? {
        return self.services[serviceCode]
    }
    
    public init(systemCode: FeliCaSystemCode, idm: String, services: [FeliCaServiceCode : [Data]]) {
        self.systemCode = systemCode
        self.idm = idm
        self.services = services
    }
}
*/
