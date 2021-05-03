//
//  ISO15693SystemInfo.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// Response of Get System Info commnad.
public struct ISO15693SystemInfo: Codable {
    public init(uniqueIdentifier: Data, dataStorageFormatIdentifier: Int, applicationFamilyIdentifier: Int, blockSize: Int, totalBlocks: Int, icReference: Int) {
        self.uniqueIdentifier = uniqueIdentifier
        self.dataStorageFormatIdentifier = dataStorageFormatIdentifier
        self.applicationFamilyIdentifier = applicationFamilyIdentifier
        self.blockSize = blockSize
        self.totalBlocks = totalBlocks
        self.icReference = icReference
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCISO15693SystemInfo) {
        self.uniqueIdentifier = coreNFCInstance.uniqueIdentifier
        self.dataStorageFormatIdentifier = coreNFCInstance.dataStorageFormatIdentifier
        self.applicationFamilyIdentifier = coreNFCInstance.applicationFamilyIdentifier
        self.blockSize = coreNFCInstance.blockSize
        self.totalBlocks = coreNFCInstance.totalBlocks
        self.icReference = coreNFCInstance.icReference
    }
    #endif
    
    /// UID.
    public var uniqueIdentifier: Data
    
    /// DSFID. Value of -1 will be returned if tag response does not contain the information.
    public var dataStorageFormatIdentifier: Int
    
    /// AFI. Value of -1 will be returned if tag response does not contain the information.
    public var applicationFamilyIdentifier: Int
    
    public var blockSize: Int
    
    /// Total number of blocks. Value of -1 will be returned if tag response does not contain the information.
    public var totalBlocks: Int
    
    /// IC Reference. Value of -1 will be returned if tag response does not contain the information.
    public var icReference: Int
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCISO15693SystemInfo {
    init(from nfcKitInstance: ISO15693SystemInfo) {
        self.init(uniqueIdentifier: nfcKitInstance.uniqueIdentifier, dataStorageFormatIdentifier: nfcKitInstance.dataStorageFormatIdentifier, applicationFamilyIdentifier: nfcKitInstance.applicationFamilyIdentifier, blockSize: nfcKitInstance.blockSize, totalBlocks: nfcKitInstance.totalBlocks, icReference: nfcKitInstance.icReference)
    }
}
#endif
