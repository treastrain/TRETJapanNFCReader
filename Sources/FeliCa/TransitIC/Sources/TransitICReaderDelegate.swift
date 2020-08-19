//
//  TransitICReaderDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/10.
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
public protocol TransitICReaderDelegate: FeliCaReaderDelegate {
    func readerSessionReadDidInvalidate(with result: Result<TransitICCardDataResponse, Error>)
}

@available(iOS 13.0, *)
extension TransitICReaderDelegate {
    public func readerSessionReadWithoutEncryptionDidInvalidate(with result: Result<FeliCaCardDataReadWithoutEncryptionResponse, Error>) {}
}

#endif
