//
//  FeliCaCardTransaction.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public protocol FeliCaCardTransaction: Codable {
    var date: Date { get }
    var type: FeliCaCardTransactionType { get }
    var difference: Int { get }
    var balance: Int { get }
}

public enum FeliCaCardTransactionType: String, Codable {
    /// 支払い
    case purchase
    /// チャージ
    case credit
    /// 交通機関
    case transit
    
    
    /// その他
    case other
    case unknown
}
