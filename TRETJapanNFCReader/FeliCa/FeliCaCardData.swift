//
//  FeliCaCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public protocol FeliCaCardData: Codable {
    var version: String { get }
    var type: FeliCaCardType { get }
    var primaryIDm: String { get }
    var primarySystemCode: FeliCaSystemCode { get }
    var contents: [FeliCaSystemCode : FeliCaSystem] { get set }
    
    mutating func convert()
    func toJSONData() -> Data?
    
    
    /// Unavailable
    // var idm: String { get }
    // var systemCode: FeliCaSystemCode { get }
    // var data: [FeliCaServiceCode : [Data]] { get }
}

extension FeliCaCardData {
    public func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
