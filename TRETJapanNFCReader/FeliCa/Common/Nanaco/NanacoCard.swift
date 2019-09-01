//
//  NanacoCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

/// nanacoカードから読み取ることができるデータの種別
public enum NanacoCardItemType: CaseIterable, FeliCaCardItemType {
    /// カード残高
    case balance
    
    
    var serviceCode: FeliCaServiceCode {
        switch self {
        case .balance:
            return 0x5597
        }
    }
    
    var blocks: Int {
        switch self {
        case .balance:
            return 1
        }
    }
}

/// nanacoカード
@available(iOS 13.0, *)
public struct NanacoCard: FeliCaCard {
    public let tag: NanacoCardTag
    public var data: NanacoCardData
    
    public init(from feliCaCommonCard: FeliCaCommonCard) {
        self.tag = feliCaCommonCard.tag
        self.data = NanacoCardData(from: feliCaCommonCard.data)
    }
    
    public init(tag: NanacoCardTag, data: NanacoCardData) {
        self.tag = tag
        self.data = data
    }
    
}

public struct NanacoCardData: FeliCaCardData {
    public let type: FeliCaCardType = .nanaco
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:]
    
    public var balance: Int?
    
    @available(iOS 13.0, *)
    fileprivate init(from feliCaCommonCardData: FeliCaCommonCardData) {
        self.idm = feliCaCommonCardData.idm
        self.systemCode = feliCaCommonCardData.systemCode
        self.data = feliCaCommonCardData.data
    }
    
    public func convert() {
        
    }
}
