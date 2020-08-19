//
//  UnivCoopICPrepaidReaderDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/16.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public protocol UnivCoopICPrepaidReaderDelegate: FeliCaReaderDelegate {
    func readerSessionReadDidInvalidate(with result: Result<UnivCoopICPrepaidCardDataResponse, Error>)
}

@available(iOS 13.0, *)
extension UnivCoopICPrepaidReaderDelegate {
    public func readerSessionReadWithoutEncryptionDidInvalidate(with result: Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) {}
}

#endif
