//
//  FeliCaReadWithoutEncryptionResponse.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/22.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

public protocol FeliCaReadWithoutEncryptionResponse {
    var feliCaData: FeliCaData { get }
    var pollingErrors: [FeliCaSystemCode : Error?] { get }
    var readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]] { get }
}
