//
//  ISO7816Status.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/11.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public enum ISO7816Status {
    /// 指定した ISO/IEC7816 の状態コードに対応するローカライズされた文字列を返す。
    /// - Parameters:
    ///   - sw1: 状態コード (SW1)
    ///   - sw2: 状態コード (SW2)
    /// - Returns: 指定した ISO/IEC7816 の状態コードに対応するローカライズされた文字列
    public static func localizedString(forStatusCode sw1: UInt8, _ sw2: UInt8) -> String {
        let statusCode = (sw1, sw2)
        switch statusCode {
        case (0x90, 0x00):
            return "正常終了"
        case (0x62, 0x00):
            return "情報なし"
        case (0x62, 0x81):
            return "出力データに異常がある"
        case (0x62, 0x82):
            return "Nc バイトを読み出す前にファイルもしくはレコードの終端に達した、または検索に失敗した"
        case (0x62, 0x83):
            return "選択したファイル DF が閉塞している"
        case (0x62, 0x84):
            return "ファイルまたはデータ制御情報が、規定の書式になっていない"
        case (0x62, 0x85):
            return "選択したファイルが、終了状態"
        case (0x62, 0x86):
            return "カードのセンサから利用可能な入力データがない"
        case (0x62, 0x87):
            return "参照レコードのうち、少なくとも1つは非活性化されている"
        case (0x63, 0x00):
            return "照合の不一致である"
        case (0x63, 0x81):
            return "今回の書き込みによって、ファイルがいっぱいになった"
        case (0x63, 0xC0):
            return "照合の不一致である（残りの試行回数: 0）"
        case (0x63, 0xC1):
            return "照合の不一致である（残りの試行回数: 1）"
        case (0x63, 0xC2):
            return "照合の不一致である（残りの試行回数: 2）"
        case (0x63, 0xC3):
            return "照合の不一致である（残りの試行回数: 3）"
        case (0x63, 0xC4):
            return "照合の不一致である（残りの試行回数: 4）"
        case (0x63, 0xC5):
            return "照合の不一致である（残りの試行回数: 5）"
        case (0x63, 0xC6):
            return "照合の不一致である（残りの試行回数: 6）"
        case (0x63, 0xC7):
            return "照合の不一致である（残りの試行回数: 7）"
        case (0x63, 0xC8):
            return "照合の不一致である（残りの試行回数: 8）"
        case (0x63, 0xC9):
            return "照合の不一致である（残りの試行回数: 9）"
        case (0x63, 0xCA):
            return "照合の不一致である（残りの試行回数: 10）"
        case (0x63, 0xCB):
            return "照合の不一致である（残りの試行回数: 11）"
        case (0x63, 0xCC):
            return "照合の不一致である（残りの試行回数: 12）"
        case (0x63, 0xCD):
            return "照合の不一致である（残りの試行回数: 13）"
        case (0x63, 0xCE):
            return "照合の不一致である（残りの試行回数: 14）"
        case (0x63, 0xCF):
            return "照合の不一致である（残りの試行回数: 15）"
        case (0x64, 0x00):
            return "ファイル制御情報に異常がある"
        case (0x65, 0x81):
            return "メモリの書き込みが失敗した"
        case (0x67, 0x00):
            return "Lc/Leが間違っている"
        case (0x68, 0x81):
            return "指定された論理チャネルの番号によるアクセス機能を提供していない"
        case (0x68, 0x82):
            return "セキュアメッセージング機能を提供していない"
        case (0x69, 0x81):
            return "ファイル構造と矛盾したコマンドである"
        case (0x69, 0x82):
            return "セキュリティステータスが満足されていない"
        case (0x69, 0x84):
            return "参照されたIEFが閉塞している"
        case (0x69, 0x85):
            return "コマンドの使用条件が満足されていない"
        case (0x69, 0x86):
            return "カレントEFが無い"
        case (0x6A, 0x80):
            return "コマンドデータフィールドのタグが正しくない"
        case (0x6A, 0x81):
            return "機能を提供していない"
        case (0x6A, 0x82):
            return "ファイルまたはアプリケーションが見つからない"
        case (0x6A, 0x83):
            return "レコードが見つからない"
        case (0x6A, 0x84):
            return "ファイル内のメモリ領域が足りない"
        case (0x6A, 0x85):
            return "Lcの値がTLV構造に矛盾している"
        case (0x6A, 0x86):
            return "P1-P2が正しくない"
        case (0x6A, 0x87):
            return "Lcの値がP1-P2に矛盾している"
        case (0x6A, 0x88):
            return "参照されたキーが正しく設定されていない"
        case (0x6B, 0x00):
            return "EF範囲外にオフセット指定した"
        case (0x6D, 0x00):
            return "INSが提供されていない"
        case (0x6E, 0x00):
            return "CLAが提供されていない"
        case (0x6F, 0x00):
            return "自己診断異常"
        default:
            return "ステータスコードが不明 sw1: \(sw1.toHexString()), sw2: \(sw2.toHexString())"
        }
    }
}
