//
//  IndividualNumberCardTag.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/06/05.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif
#if canImport(TRETJapanNFCReader_ISO7816)
import TRETJapanNFCReader_ISO7816
#endif

@available(iOS 13.0, *)
internal typealias IndividualNumberCardTag = NFCISO7816Tag

@available(iOS 13.0, *)
extension IndividualNumberCardTag {
    
    internal func selectEF(data: [UInt8], completionHandler: @escaping ISO7816SendCommandCompletionHandler) {
        self.selectFile(p1Parameter: 0x02, p2Parameter: 0x0C, data: Data(data), expectedResponseLength: -1, completionHandler: completionHandler)
    }
    
    internal func selectEF(data: [UInt8]) -> ISO7816SendCommandCompletion {
        var completion: ISO7816SendCommandCompletion!
        let semaphore = DispatchSemaphore(value: 0)
        self.selectEF(data: data) { (responseData, sw1, sw2, error) in
            completion = (responseData, sw1, sw2, error)
            semaphore.signal()
        }
        semaphore.wait()
        return completion
    }
}

#endif
