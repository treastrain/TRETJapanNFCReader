//
//  FeliCaReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
public protocol FeliCaReaderSessionDelegate: JapanNFCReaderSessionDelegate {
    func feliCaReaderSession(didRead feliCaCardData: FeliCaCardData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?)
    func feliCaReaderSession(didInvalidateWithError pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?)
    
    func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?)
    
    // @available(*, unavailable)
    // func feliCaReaderSession(didRead feliCaCard: FeliCaCard)
}

@available(iOS 13.0, *)
public extension FeliCaReaderSessionDelegate {
    func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
    }
}

#endif
