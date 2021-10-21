//
//  JapanIndividualNumberCardItem.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

import NFCKitReaderCore

public enum JapanIndividualNumberCardItem: CaseIterable {
    /// 署名用電子証明書
    case digitalSignature
    /// 利用者証明用電子証明書
    case userAuthentication
    /// 券面事項入力補助用
    case cardInfoInputSupportApplication
    /// 個人番号カード用（住基カード用）
    case individualNumberCard
}

extension JapanIndividualNumberCardItem {
    var aid: Data {
        switch self {
        case .digitalSignature:
            return Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        case .userAuthentication:
            return Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        case .cardInfoInputSupportApplication:
            return Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x04, 0x08])
        case .individualNumberCard:
            return Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x01, 0x00])
        }
    }
}
