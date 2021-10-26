//
//  JapanIndividualNumberCardReader+Commands.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/21.
//

#if os(iOS)
import NFCKitReaderCore

@available(iOS 13.0, *)
extension CoreNFC.NFCISO7816Tag {
    public func selectDF(data: Data, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        selectFile(p1Parameter: 0x04, p2Parameter: 0x0C, data: data, expectedResponseLength: -1, completionHandler: completionHandler)
    }
    
    public func selectEF(data: Data, completionHandler: @escaping (Data, UInt8, UInt8, Error?) -> Void) {
        selectFile(p1Parameter: 0x02, p2Parameter: 0x0C, data: data, expectedResponseLength: -1, completionHandler: completionHandler)
    }
}
#endif
