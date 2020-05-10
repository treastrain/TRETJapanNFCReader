//
//  IndividualNumberCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

/// マイナンバーカードから読み取ることができるデータの種別
public enum IndividualNumberCardItem: CaseIterable {
    /// 公的個人認証AP
    case 公的個人認証AP
    /// 券面事項確認AP
    case 券面事項確認AP
    /// 券面事項入力補助AP
    case 券面事項入力補助AP
    /// 住基AP
    case 住基AP
}

/// マイナンバーカード
@available(iOS 13.0, *)
public struct IndividualNumberCard {
    internal var tag: IndividualNumberCardTag
    
    public var token: String?
}

#endif
