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
    
    // MARK: - Sending FeliCa Commands
    
    /// Sends the FeliCa command packet data to the tag.
    /// - Parameters:
    ///   - commandPacket: Command packet send to the FeliCa card. Maximum packet length is 254. Data length (LEN) byte and CRC bytes are calculated and inserted automatically to the provided packet data frame.
    ///   - resultHandler: Completion handler called when the operation is completed. A `NFCErrorDomain` error is returned when there is a communication issue with the tag.
    ///
    /// Transmission of FeliCa Command Packet Data at the applicaiton layer. Refer to the FeliCa specification for details. Manufacturer ID (IDm) of the currently selected system can be read from the currentIDm property.
    public func sendFeliCaCommand(commandPacket: Data, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func sendFeliCaCommand(commandPacket: Data, completionHandler: @escaping (Data, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    private var _core: Any?
    @available(iOS 13.0, *)
    internal var core: CoreNFC.NFCFeliCaTag {
        get {
            return _core as! CoreNFC.NFCFeliCaTag
        }
        set {
            _core = newValue
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
