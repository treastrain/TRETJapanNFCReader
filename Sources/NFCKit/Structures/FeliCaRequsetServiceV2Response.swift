//
//  FeliCaRequsetServiceV2Response.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/01.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Response from Request Service V2 command.
public struct FeliCaRequsetServiceV2Response: Codable {
    public init(statusFlag1: Int, statusFlag2: Int, encryptionIdentifier: FeliCaEncryptionId, nodeKeyVersionListAES: [Data]?, nodeKeyVersionListDES: [Data]?) {
        self.statusFlag1 = statusFlag1
        self.statusFlag2 = statusFlag2
        self.encryptionIdentifier = encryptionIdentifier
        self.nodeKeyVersionListAES = nodeKeyVersionListAES
        self.nodeKeyVersionListDES = nodeKeyVersionListDES
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCFeliCaRequsetServiceV2Response) {
        self.statusFlag1 = coreNFCInstance.statusFlag1
        self.statusFlag2 = coreNFCInstance.statusFlag2
        self.encryptionIdentifier = coreNFCInstance.encryptionIdentifier.rawValue
        self.nodeKeyVersionListAES = coreNFCInstance.nodeKeyVersionListAES
        self.nodeKeyVersionListDES = coreNFCInstance.nodeKeyVersionListDES
    }
    #endif
    
    /// Status flag 1.
    public var statusFlag1: Int

    /// Status flag 2.
    public var statusFlag2: Int

    /// Encryption identifier.
    public var encryptionIdentifier: FeliCaEncryptionId

    /// Node key version list for AES.
    public var nodeKeyVersionListAES: [Data]?

    /// Node key version list for DES.
    public var nodeKeyVersionListDES: [Data]?
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCFeliCaRequsetServiceV2Response {
    init(from nfcKitInstance: FeliCaRequsetServiceV2Response) {
        self.init(statusFlag1: nfcKitInstance.statusFlag1, statusFlag2: nfcKitInstance.statusFlag2, encryptionIdentifier: NFCFeliCaEncryptionId(rawValue: nfcKitInstance.encryptionIdentifier)!, nodeKeyVersionListAES: nfcKitInstance.nodeKeyVersionListAES, nodeKeyVersionListDES: nfcKitInstance.nodeKeyVersionListDES)
    }
}
#endif
