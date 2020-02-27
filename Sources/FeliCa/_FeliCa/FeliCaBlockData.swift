//
//  FeliCaBlockData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/03.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct FeliCaBlockData: Codable, Equatable {
    public let status1: Int
    public let status2: Int
    public let blockData: [Data]
    
    public init(status1: Int, status2: Int, blockData: [Data]) {
        self.status1 = status1
        self.status2 = status2
        self.blockData = blockData
    }
    
    public static func == (lhs: FeliCaBlockData, rhs: FeliCaBlockData) -> Bool {
        return lhs.status1 == rhs.status1 &&
            lhs.status2 == rhs.status2 &&
            lhs.blockData == rhs.blockData
    }
}
