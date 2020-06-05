//
//  ISO7816ReaderCommands.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/18.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

/// ISO/IEC 7816-4:2013、JIS X 6320-4:2017 に準拠した `NFCISO7816Tag` で用いるコマンド
@available(iOS 13.0, *)
public extension NFCISO7816Tag {
    
    /// コマンド操作が完了した後にリーダーセッションが呼び出す handler
    /// - Parameters:
    ///   - responseData: レスポンスデータ。コマンド操作が正常に完了しても空の場合がある。
    ///   - sw1: 状態バイト SW1。
    ///   - sw2: 状態バイト SW2。
    ///   - error: コマンド操作が正常に完了した場合には `nil`、タグとの通信に問題がある場合は [NSError](apple-reference-documentation://hsInK_-ThL)。
    typealias ISO7816SendCommandCompletionHandler = (_ responseData: Data, _ sw1: UInt8, _ sw2: UInt8, _ error: Error?) -> Void
    
    /// ISO/IEC 7816-4 で規定されている READ BINARY コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func readBinary(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xB0, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている WRITE BINARY コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func writeBinary(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xD0, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている UPDATE BINARY コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func updateBinary(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xD6, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている READ RECORDS コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func readRecords(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xB2, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている WRITE RECORD コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func writeRecord(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xD2, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている APPEND RECORD コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func appendRecord(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xE2, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている UPDATE RECORD コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func updateRecord(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xDC, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている SELECT FILE コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func selectFile(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0xA4, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている VERIFY コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func verify(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x20, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている INTERNAL AUTHENTICATE コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func internalAuthenticate(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x88, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている EXTERNAL AUTHENTICATE コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func externalAuthenticate(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x82, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
    
    /// ISO/IEC 7816-4 で規定されている GET CHALLENGE コマンド
    /// - Parameters:
    ///   - p1Parameter: パラメーターバイト P1。
    ///   - p2Parameter: パラメーターバイト P2。
    ///   - data: 送信するデータ。
    ///   - expectedResponseLength: 期待されるレスポンスデータバイトの長さ (Le)。レスポンスデータフィールドの最大バイト数を期待する場合は `0` を指定する。レスポンスデータフィールドが存在しないことを期待する場合は `-1` を指定する。
    ///   - completionHandler: コマンド操作が完了した後にリーダーセッションが呼び出す handler
    func getChallenge(p1Parameter: UInt8, p2Parameter: UInt8, data: Data, expectedResponseLength: Int, completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        let apdu = NFCISO7816APDU(instructionClass: 0x00, instructionCode: 0x84, p1Parameter: p1Parameter, p2Parameter: p2Parameter, data: data, expectedResponseLength: expectedResponseLength)
        
        self.sendCommand(apdu: apdu, completionHandler: completionHandler)
    }
}

#endif
