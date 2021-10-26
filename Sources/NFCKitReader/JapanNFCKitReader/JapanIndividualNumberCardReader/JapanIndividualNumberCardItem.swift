//
//  JapanIndividualNumberCardItem.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

import NFCKitReaderCore

public enum JapanIndividualNumberCardItem: CaseIterable {
    /// Electronic Certificate for the Bearer's Signature (署名用電子証明書)
    case electronicCertificateForTheBearersSignature
    /// Electronic Certificate for User Identification (利用者証明用電子証明書)
    case electronicCertificateForUserIdentification
    /// Card Info Input Support Application (券面事項入力補助用)
    case cardInfoInputSupportApplication
    /// Basic Resident Registration (個人番号カード用（住民基本台帳用）)
    case basicResidentRegistration
}

extension JapanIndividualNumberCardItem {
    var aid: Data {
        switch self {
        case .electronicCertificateForTheBearersSignature:
            return Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        case .electronicCertificateForUserIdentification:
            return Data([0xD3, 0x92, 0xF0, 0x00, 0x26, 0x01, 0x00, 0x00, 0x00, 0x01])
        case .cardInfoInputSupportApplication:
            return Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x04, 0x08])
        case .basicResidentRegistration:
            return Data([0xD3, 0x92, 0x10, 0x00, 0x31, 0x00, 0x01, 0x01, 0x01, 0x00])
        }
    }
}
