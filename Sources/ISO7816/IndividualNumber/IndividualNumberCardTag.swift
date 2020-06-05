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

#endif
