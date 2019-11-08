//
//  NTasuCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// エヌタス
public struct NTasuCardData: FeliCaCardData {
    public let type: FeliCaCardType = .ntasu
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var transactions: [NTasuCardTransaction]?
    
    public func convert() {
        
    }
}

/// エヌタス の利用履歴
public struct NTasuCardTransaction: FeliCaCardTransaction {
    public var date: Date
    public var type: FeliCaCardTransactionType
    public var difference: Int
    public var balance: Int
}


