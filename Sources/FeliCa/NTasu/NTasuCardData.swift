//
//  NTasuCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// エヌタス
public struct NTasuCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType = .ntasu
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var transactions: [NTasuCardTransaction]?
    
    public func convert() {
        
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}

/// エヌタス の利用履歴
public struct NTasuCardTransaction: FeliCaCardTransaction {
    public var date: Date
    public var type: FeliCaCardTransactionType
    public var difference: Int
    public var balance: Int
}


