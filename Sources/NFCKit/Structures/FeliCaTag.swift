//
// FeliCaTag.swift
// TRETNFCKit
//
// Created by treastrain on 2021/05/16.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

/// An interface for interacting with a FeliCa™ tag.
///
/// FeliCa is a trademark of Sony Corporation.
public struct FeliCaTag {
    /// The system code most recently selected by the reader session during a polling sequence.
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    public var currentSystemCode: Data {
        self.core.currentSystemCode
    }
    #endif
    
    /// The manufacturer identifier for the system currently selected by the reader session.
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    public var currentIDm: Data {
        self.core.currentIDm
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    private var _core: Any?
    @available(iOS 13.0, *)
    internal var core: CoreNFC.NFCFeliCaTag {
        get {
            return self._core as! CoreNFC.NFCFeliCaTag
        }
        set {
            self._core = newValue
        }
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    internal init(from core: CoreNFC.NFCFeliCaTag) {
        self.core = core
    }
    #endif
}
