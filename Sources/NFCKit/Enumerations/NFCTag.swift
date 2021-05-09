//
//  NFCTag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/09.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// An object that represents an NFC tag object.
public enum NFCTag {
    /// FeliCa tag.
    case feliCa // (FeliCaTag)
    
    /// ISO14443-4 type A / B tag with ISO7816 communication.
    case iso7816 // (ISO7816Tag)
    
    /// ISO15693 tag.
    case iso15693 // (ISO15693Tag)
    
    /// MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443.
    case miFare // (MiFareTag)
    
    /// Check whether a detected tag is available.  Returns `true` if tag is available in the current reader session. A tag remove from the RF field will become unavailable.  Tag in disconnected state will return `false`.
    public var isAvailable: Bool {
        return false
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCTag) {
        switch coreNFCInstance {
        case .feliCa(_):
            self = .feliCa
        case .iso7816(_):
            self = .iso7816
        case .iso15693(_):
            self = .iso15693
        case .miFare(_):
            self = .miFare
        @unknown default:
            fatalError()
        }
    }
    #endif
}

#if os(iOS) && !targetEnvironment(macCatalyst)
public extension Array where Element == NFCTag {
    @available(iOS 13.0, *)
    init(from coreNFCInstances: [CoreNFC.NFCTag]) {
        self = coreNFCInstances.map { .init(from: $0) }
    }
}
#endif
