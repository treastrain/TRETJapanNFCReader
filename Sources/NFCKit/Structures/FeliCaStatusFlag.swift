//
//  FeliCaStatusFlag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/02.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Response status flags.
public struct FeliCaStatusFlag: Codable {
    public init(statusFlag1: Int, statusFlag2: Int) {
        self.statusFlag1 = statusFlag1
        self.statusFlag2 = statusFlag2
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCFeliCaStatusFlag) {
        self.statusFlag1 = coreNFCInstance.statusFlag1
        self.statusFlag2 = coreNFCInstance.statusFlag2
    }
    #endif
    
    /// Status flag 1.
    public var statusFlag1: Int
    
    /// Status flag 2.
    public var statusFlag2: Int
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCFeliCaStatusFlag {
    init(from nfcKitInstance: FeliCaStatusFlag) {
        self.init(statusFlag1: nfcKitInstance.statusFlag1, statusFlag2: nfcKitInstance.statusFlag2)
    }
}
#endif
