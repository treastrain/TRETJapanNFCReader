//
//  FeliCa+NFCFeliCaTag.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension NFCFeliCaTag {
    /// FeliCa カードの仕様で定義されている Read Without Encryption コマンドを、blockList の要素数が13~24の場合において継続して処理できるように分けてタグに送信します。
    /// - Parameter serviceCode: サービスコード
    /// - Parameter blockList: ブロックリスト
    /// - Parameter completionHandler: レスポンスデータ
    /// - Parameter status1: ステータスフラグ 1
    /// - Parameter status2: ステータスフラグ 2
    /// - Parameter blockData: ブロックデータ
    /// - Parameter error: エラー
    func readWithoutEncryption24(serviceCode: Data, blockList: [Data], completionHandler: @escaping (_ status1: Int, _ status2: Int, _ blockData: [Data], _ error: Error?) -> Void) {
        
        var completionBlockData: [Data] = []
        
        let blockLists = blockList.split(count: 12)
        let blockList = blockLists.first ?? []
        self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockList) { (status1, status2, blockData, error) in
            
            if let error = error {
                completionHandler(status1, status2, blockData, error)
                return
            }
            
            guard status1 == 0x00, status2 == 0x00, blockLists.count >= 2 else {
                completionHandler(status1, status2, blockData, error)
                return
            }
            
            completionBlockData += blockData
            
            self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockLists[1]) { (status1, status2, blockData, error) in
                
                completionBlockData += blockData
                completionHandler(status1, status2, completionBlockData, error)
            }
        }
    }
}
