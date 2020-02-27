//
//  TransitICCardData.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

/// 交通系ICカードのデータ
public struct TransitICCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType = .transitIC
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }
    
    public var balance: Int?
    public var transactionsData: [Data]?
    public var entryExitInformationsData: [Data]?
    public var sfEntryInformationsData: [Data]?
    
    public var sapicaPoints: Int?
    
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
    }
    
    public init(idm: String, systemCode: FeliCaSystemCode, data: FeliCaData) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
        self.contents = data
        self.convert()
    }
    
    public mutating func convert() {
        for (systemCode, system) in self.contents {
            switch systemCode {
            case self.primarySystemCode:
                let services = system.services
                for (serviceCode, blockData) in services {
                    let blockData = blockData.blockData
                    switch TransitICCardItemType(serviceCode) {
                    case .balance:
                        self.convertToBalance(blockData)
                    case .transactions:
                        self.convertToTransactions(blockData)
                    case .entryExitInformations:
                        self.convertToEntryExitInformations(blockData)
                    case .sfEntryInformations:
                        self.convertToSFEntryInformations(blockData)
                    case .sapicaPoints:
                        self.convertToSapicaPoints(blockData)
                    case .none:
                        break
                    }
                }
            default:
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
    
    private mutating func convertToSapicaPoints(_ blockData: [Data]) {
        let data = blockData.first!
        let points = data.toIntReversed(0, 2)
        self.sapicaPoints = points
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}
