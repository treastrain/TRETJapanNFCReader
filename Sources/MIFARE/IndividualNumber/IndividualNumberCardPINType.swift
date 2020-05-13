//
//  IndividualNumberCardPINType.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/13.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum IndividualNumberCardPINType {
    /// 署名用電子証明書（公的個人認証 署名用）
    case digitalSignature
    /// 利用者証明用電子証明書（公的個人認証 利用者証明用）
    case userAuthentication
    /// 券面事項入力補助用
    case cardInfoInputSupport
    /// 個人番号カード用（住民基本台帳事務用）
    case individualNumber
    
    public var description: String {
        switch self {
        case .digitalSignature:
            return "署名用電子証明書（公的個人認証 署名用）"
        case .userAuthentication:
            return "利用者証明用電子証明書（公的個人認証 利用者証明用）"
        case .cardInfoInputSupport:
            return "券面事項入力補助用"
        case .individualNumber:
            return "個人番号カード用（住民基本台帳事務用）"
        }
    }
}
