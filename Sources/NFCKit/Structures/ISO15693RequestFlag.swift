//
//  ISO15693RequestFlag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct ISO15693RequestFlag: OptionSet, Codable {
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 14.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCISO15693RequestFlag) {
        self.rawValue = coreNFCInstance.rawValue
    }
    #endif
    
    public static var dualSubCarriers = Self(rawValue: 1 << 0)
    
    public static var highDataRate = Self(rawValue: 1 << 1)
    
    public static var protocolExtension = Self(rawValue: 1 << 3)
    
    public static var select = Self(rawValue: 1 << 4)
    
    public static var address = Self(rawValue: 1 << 5)
    
    public static var option = Self(rawValue: 1 << 6)
    
    public static var commandSpecificBit8 = Self(rawValue: 1 << 7)
    
    public let rawValue: UInt8
}

extension ISO15693RequestFlag: CaseIterable {
    public static var allCases: [Self] = [
        .dualSubCarriers,
        .highDataRate,
        .protocolExtension,
        .select,
        .address,
        .option,
        .commandSpecificBit8
    ]
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
public extension CoreNFC.NFCISO15693RequestFlag {
    init(from nfcKitInstance: ISO15693RequestFlag) {
        self.init(rawValue: nfcKitInstance.rawValue)
    }
}
#endif

extension ISO15693RequestFlag {
    @available(*, renamed: "ISO15693RequestFlag.address")
    public static var RequestFlagAddress = Self.address
    
    @available(*, renamed: "ISO15693RequestFlag.dualSubCarriers")
    public static var RequestFlagDualSubCarriers = Self.dualSubCarriers
    
    @available(*, renamed: "ISO15693RequestFlag.highDataRate")
    public static var RequestFlagHighDataRate = Self.highDataRate
    
    @available(*, renamed: "ISO15693RequestFlag.option")
    public static var RequestFlagOption = Self.option
    
    @available(*, renamed: "ISO15693RequestFlag.protocolExtension")
    public static var RequestFlagProtocolExtension = Self.protocolExtension
    
    @available(*, renamed: "ISO15693RequestFlag.select")
    public static var RequestFlagSelect = Self.select
}
