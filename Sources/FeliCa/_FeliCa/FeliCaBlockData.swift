//
//  FeliCaBlockData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/03.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct FeliCaBlockData: Codable {
    public let status1: Int
    public let status2: Int
    public let blockData: [Data]
    
    public init(status1: Int, status2: Int, blockData: [Data]) {
        self.status1 = status1
        self.status2 = status2
        self.blockData = blockData
    }
}
