//
//  IndividualNumberReaderError.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum IndividualNumberReaderError: Error {
    case needPIN
    case incorrectPIN(Int)
    case incorrectPINFormat
}

extension IndividualNumberReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .needPIN:
            return "暗証番号の入力が必要です"
        case .incorrectPIN(let remaining):
            return "暗証番号が違います（残りの試行可能回数: \(remaining)）"
        case .incorrectPINFormat:
            return "暗証番号の形式が正しくありません"
        }
    }
}
