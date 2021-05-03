//
//  FeliCaEncryptionId.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/01.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Encryption Identifier parameter in response of Request Service V2.
public typealias FeliCaEncryptionId = Int

public extension FeliCaEncryptionId {
    /// An identifier that indicates the Advanced Encryption Standard (AES) encryption algorithm.
    static var AES = 79
    /// An identifier that indicates the Data Encryption Standard (DES) encryption algorithm.
    static var AES_DES = 65
}

extension FeliCaEncryptionId: CaseIterable {
    public static var allCases: [FeliCaEncryptionId] = [.AES, .AES_DES]
}
