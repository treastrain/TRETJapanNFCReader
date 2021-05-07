//
//  NFCTagReaderSession+PollingOption.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public extension NFCTagReaderSession {
    /// Options that determine the type of tags that a reader session should detect during a polling sequence.
    ///
    /// You can combine options to have the reader session scan and detect different tag types at the same time.
    struct PollingOption : OptionSet, Codable {
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        #if os(iOS) && !targetEnvironment(macCatalyst)
        @available(iOS 13.0, *)
        public init(from coreNFCInstance: CoreNFC.NFCTagReaderSession.PollingOption) {
            self.rawValue = coreNFCInstance.rawValue
        }
        #endif
        
        /// The option for detecting ISO 7816-compatible and MIFARE tags.
        ///
        /// Supports NFC type A and B modulation.
        public static var iso14443 = Self(rawValue: 1 << 0)
        
        /// The option for detecting ISO 15693 tags.
        public static var iso15693 = Self(rawValue: 1 << 1)
        
        /// The option for detecting FeliCa tags.
        public static var iso18092 = Self(rawValue: 1 << 2)
        
        public var rawValue: Int
    }
}

extension NFCTagReaderSession.PollingOption: CaseIterable {
    public static var allCases: [Self] = [
        .iso14443,
        .iso15693,
        .iso18092,
    ]
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 13.0, *)
public extension CoreNFC.NFCTagReaderSession.PollingOption {
    init(from nfcKitInstance: NFCTagReaderSession.PollingOption) {
        self.init(rawValue: nfcKitInstance.rawValue)
    }
}
#endif
