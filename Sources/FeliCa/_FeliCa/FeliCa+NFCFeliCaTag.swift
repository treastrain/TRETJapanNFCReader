//
//  FeliCa+NFCFeliCaTag.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
extension NFCFeliCaTag {
    /// FeliCa カードの仕様で定義されている Read Without Encryption コマンドを、blockList の要素数が13~36の場合において継続して処理できるように分けてタグに送信します。
    /// - Parameter serviceCode: サービスコード
    /// - Parameter blockList: ブロックリスト
    /// - Parameter completionHandler: レスポンスデータ
    /// - Parameter status1: ステータスフラグ 1
    /// - Parameter status2: ステータスフラグ 2
    /// - Parameter blockData: ブロックデータ
    /// - Parameter error: エラー
    public func readWithoutEncryption36(serviceCode: Data, blockList: [Data], completionHandler: @escaping (_ status1: Int, _ status2: Int, _ blockData: [Data], _ error: Error?) -> Void) {
        
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
                
                if let error = error {
                    completionHandler(status1, status2, completionBlockData, error)
                    return
                }
                
                completionBlockData += blockData
                
                guard status1 == 0x00, status2 == 0x00, blockLists.count >= 3 else {
                    completionHandler(status1, status2, completionBlockData, error)
                    return
                }
                
                self.readWithoutEncryption(serviceCodeList: [serviceCode], blockList: blockLists[2]) { (status1, status2, blockData, error) in
                    
                    completionBlockData += blockData
                    completionHandler(status1, status2, completionBlockData, error)
                }
            }
        }
    }
    
    @available(*, unavailable, renamed: "readWithoutEncryption36(serviceCode:blockList:completionHandler:)")
    public func readWithoutEncryption24(serviceCode: Data, blockList: [Data], completionHandler: @escaping (_ status1: Int, _ status2: Int, _ blockData: [Data], _ error: Error?) -> Void) {
    }
    
    /// FeliCa カードの仕様で定義されている Read Without Encryption コマンドを、blockList の要素数が13~36の場合において継続して処理できるように分けてタグに送信します。レスポンスデータは同期的に返されます。
    /// - Parameters:
    ///   - serviceCode: サービスコード
    ///   - blockList: ブロックリスト
    public func readWithoutEncryption36(serviceCode: Data, blockList: [Data]) -> (status1: Int, status2: Int, blockData: [Data], error: Error?) {
        var resultStatus1: Int!
        var resultStatus2: Int!
        var resultBlockData: [Data]!
        var resultError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.readWithoutEncryption36(serviceCode: serviceCode, blockList: blockList) { (status1, status2, blockData, error) in
            resultStatus1 = status1
            resultStatus2 = status2
            resultBlockData = blockData
            resultError = error
            semaphore.signal()
        }
        semaphore.wait()
        return (resultStatus1, resultStatus2, resultBlockData, resultError)
    }
    
    /// Sends the Polling command as defined by FeliCa card specification to the tag. Response data is returned synchronously.
    /// - Parameters:
    ///   - systemCode: Designation of System Code.
    ///   - requestCode: Designation of Request Data.
    ///   - timeSlot: Designation of maximum number of slots possible to respond.
    public func polling(systemCode: Data, requestCode: PollingRequestCode, timeSlot: PollingTimeSlot) -> (pmm: Data, systemCode: Data, error: Error?) {
        var resultPMm: Data!
        var resultSystemCode: Data!
        var resultError: Error?
        let semaphore = DispatchSemaphore(value: 0)
        self.polling(systemCode: systemCode, requestCode: requestCode, timeSlot: timeSlot) { (pmm, systemCode, error) in
            resultPMm = pmm
            resultSystemCode = systemCode
            resultError = error
            semaphore.signal()
        }
        semaphore.wait()
        return (resultPMm, resultSystemCode, resultError)
    }
}

#endif
