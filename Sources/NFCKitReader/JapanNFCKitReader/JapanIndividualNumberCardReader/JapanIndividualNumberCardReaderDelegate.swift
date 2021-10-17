//
//  JapanIndividualNumberCardReaderDelegate.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

#if os(iOS)
import NFCKitReaderCore

@available(iOS 13.0, *)
public protocol JapanIndividualNumberCardReaderDelegate {
    func japanIndividualNumberCardReaderDidBecomeActive(_ reader: JapanIndividualNumberCardReader)
    func japanIndividualNumberCardReader(_ reader: JapanIndividualNumberCardReader, didInvalidateWithError error: Error)
}
#endif
