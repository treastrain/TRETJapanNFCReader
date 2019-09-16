//
//  TransitICCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// 交通系ICカードのデータ
public struct TransitICCardData: FeliCaCardData {
    public let type: FeliCaCardType = .transitIC
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var transactionsData: [Data]?
    public var entryExitInformationsData: [Data]?
    public var sfEntryInformationsData: [Data]?
    
    @available(iOS 13.0, *)
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.idm = idm
        self.systemCode = systemCode
    }
    
    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch TransitICCardItemType(key) {
            case .balance:
                self.convertToBalance(blockData)
            case .transactions:
                self.convertToTransactions(blockData)
            case .entryExitInformations:
                self.convertToEntryExitInformations(blockData)
            case .sfEntryInformations:
                self.convertToSFEntryInformations(blockData)
            case .none:
                break
            }
        }
    }
    
    private mutating func convertToBalance(_ blockData: [Data]) {
        let data = blockData.first!
        let balance = data.toIntReversed(11, 12)
        self.balance = balance
    }
    
    private mutating func convertToTransactions(_ blockData: [Data]) {
        self.transactionsData = blockData
    }
    
    private mutating func convertToEntryExitInformations(_ blockData: [Data]) {
        self.entryExitInformationsData = blockData
    }
    
    private mutating func convertToSFEntryInformations(_ blockData: [Data]) {
        self.sfEntryInformationsData = blockData
    }
}
