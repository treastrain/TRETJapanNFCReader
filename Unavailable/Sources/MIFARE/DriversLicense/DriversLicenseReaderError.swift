//
//  DriversLicenseReaderError.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum DriversLicenseReaderError: Error {
    case needPIN
    case incorrectPIN(Int)
    case incorrectPINFormat
    case enteredPINWasIgnored
}

extension DriversLicenseReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .needPIN:
            return "暗証番号の入力が必要です"
        case .incorrectPIN(let remaining):
            return "暗証番号が違います（残りの試行可能回数: \(remaining)）"
        case .incorrectPINFormat:
            return "暗証番号の形式が正しくありません"
        case .enteredPINWasIgnored:
            return "運転免許証に暗証番号が設定されていないため、入力された暗証番号は無視されました"
        }
    }
}
