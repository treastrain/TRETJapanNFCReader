//
//  ISO15693ResponseFlag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct ISO15693ResponseFlag: OptionSet, Codable {
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCISO15693ResponseFlag) {
        self.rawValue = coreNFCInstance.rawValue
    }
    #endif
    
    public static var error = Self(rawValue: 1 << 0)

    public static var responseBufferValid = Self(rawValue: 1 << 1)

    public static var finalResponse = Self(rawValue: 1 << 2)

    public static var protocolExtension = Self(rawValue: 1 << 3)

    public static var blockSecurityStatusBit5 = Self(rawValue: 1 << 4)

    public static var blockSecurityStatusBit6 = Self(rawValue: 1 << 5)

    public static var waitTimeExtension = Self(rawValue: 1 << 6)
    
    public let rawValue: UInt8
}

extension ISO15693ResponseFlag: CaseIterable {
    public static var allCases: [ISO15693ResponseFlag] = [
        .error,
        .responseBufferValid,
        .finalResponse,
        .protocolExtension,
        .blockSecurityStatusBit5,
        .blockSecurityStatusBit6,
        .waitTimeExtension,
    ]
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCISO15693ResponseFlag {
    init(from nfcKitInstance: ISO15693ResponseFlag) {
        self.init(rawValue: nfcKitInstance.rawValue)
    }
}
#endif
