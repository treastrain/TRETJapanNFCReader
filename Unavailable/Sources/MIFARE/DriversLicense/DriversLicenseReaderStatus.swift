//
//  DriversLicenseReaderStatus.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum DriversLicenseReaderStatus: String {
    case x9000 // "正常終了"
    case x6283 // "DFが閉塞している"
    case x6300 // "照合の不一致である"
    case x63C0 // "照合の不一致である（残りの試行回数: 0）"
    case x63C1 // "照合の不一致である（残りの試行回数: 1）"
    case x63C2 // "照合の不一致である（残りの試行回数: 2）"
    case x63C3 // "照合の不一致である（残りの試行回数: 3）"
    case x6400 // "ファイルの制御情報に異常がある"
    case x6581 // "メモリの書き込みが失敗した"
    case x6700 // "Lc/Leが間違っている"
    case x6881 // "指定された論理チャネルの番号によるアクセス機能を提供しない"
    case x6882 // "セキュアメッセージング機能を提供しない"
    case x6981 // "ファイル構造と矛盾したコマンドである"
    case x6982 // "セキュリティステータスが満足されない"
    case x6984 // "参照されたIEFが閉塞している"
    case x6986 // "カレントEFが無い"
    case x6A81 // "機能を提供しない"
    case x6A82 // "アクセス対象ファイルが無い"
    case x6A86 // "P1-P2の値が正しくない"
    case x6A87 // "Lcの値がP1-P2に矛盾している"
    case x6A88 // "参照された鍵が正しく設定されていない"
    case x6B00 // "EF範囲外にオフセット指定した"
    case x6D00 // "INSが提供されていない"
    case x6E00 // "クラスが提供されていない"
    case x0000 // unknown
    
    init(sw1: UInt8, sw2: UInt8) {
        var sw1 = String(sw1, radix: 16).uppercased()
        var sw2 = String(sw2, radix: 16).uppercased()
        if sw1 == "0" {
            sw1 = "00"
        }
        if sw2 == "0" {
            sw2 = "00"
        }
        let rawValue = "x" + sw1 + sw2
        self = DriversLicenseReaderStatus(rawValue: rawValue)!
    }
    
    public var description: String {
        switch self {
        case .x9000:
            return "正常終了"
        case .x6283:
            return "DFが閉塞している"
        case .x6300:
            return "照合の不一致である"
        case .x63C0:
            return "照合の不一致である（残りの試行回数: 0）"
        case .x63C1:
            return "照合の不一致である（残りの試行回数: 1）"
        case .x63C2:
            return "照合の不一致である（残りの試行回数: 2）"
        case .x63C3:
            return "照合の不一致である（残りの試行回数: 3）"
        case .x6400:
            return "ファイルの制御情報に異常がある"
        case .x6581:
            return "メモリの書き込みが失敗した"
        case .x6700:
            return "Lc/Leが間違っている"
        case .x6881:
            return "指定された論理チャネルの番号によるアクセス機能を提供しない"
        case .x6882:
            return "セキュアメッセージング機能を提供しない"
        case .x6981:
            return "ファイル構造と矛盾したコマンドである"
        case .x6982:
            return "セキュリティステータスが満足されない"
        case .x6984:
            return "参照されたIEFが閉塞している"
        case .x6986:
            return "カレントEFが無い"
        case .x6A81:
            return "機能を提供しない"
        case .x6A82:
            return "アクセス対象ファイルが無い"
        case .x6A86:
            return "P1-P2の値が正しくない"
        case .x6A87:
            return "Lcの値がP1-P2に矛盾している"
        case .x6A88:
            return "参照された鍵が正しく設定されていない"
        case .x6B00:
            return "EF範囲外にオフセット指定した"
        case .x6D00:
            return "INSが提供されていない"
        case .x6E00:
            return "クラスが提供されていない"
        case .x0000:
            return "Unknown"
        }
    }
}
