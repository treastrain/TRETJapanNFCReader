//
//  ISO15693MultipleBlockSecurityStatus.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/02.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Response of Get Multiple Block Security Status command.
public struct ISO15693MultipleBlockSecurityStatus: Codable {
    public init(blockSecurityStatus: [Int]) {
        self.blockSecurityStatus = blockSecurityStatus
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCISO15693MultipleBlockSecurityStatus) {
        self.blockSecurityStatus = coreNFCInstance.blockSecurityStatus
    }
    #endif

    /// Array of block security status information
    public var blockSecurityStatus: [Int]
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCISO15693MultipleBlockSecurityStatus {
    init(from nfcKitInstance: ISO15693MultipleBlockSecurityStatus) {
        self.init(blockSecurityStatus: nfcKitInstance.blockSecurityStatus)
    }
}
#endif
