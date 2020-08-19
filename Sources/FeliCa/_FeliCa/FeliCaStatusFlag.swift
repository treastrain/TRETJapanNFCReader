//
//  FeliCaStatusFlag.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/16.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct FeliCaStatusFlag {
    public var statusFlag1: Int
    public var statusFlag2: Int
    
    init(_ statusFlag1: Int, _ statusFlag2: Int) {
        self.statusFlag1 = statusFlag1
        self.statusFlag2 = statusFlag2
    }
    
    #if canImport(CoreNFC)
    @available(iOS 14.0, *)
    init(_ statusFlag: CoreNFC.NFCFeliCaStatusFlag) {
        self.statusFlag1 = statusFlag.statusFlag1
        self.statusFlag2 = statusFlag.statusFlag2
    }
    #endif
    
    public var isSucceeded: Bool {
        return statusFlag1 == 0x00 && statusFlag2 == 0x00
    }
}
