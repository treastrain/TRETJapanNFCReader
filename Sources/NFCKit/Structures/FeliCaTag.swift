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
    
    // MARK: - Reading and Writing Without Encryption
    
    /// Sends the Read Without Encryption command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - serviceCodeList: Service Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 16 inclusive. Each service code should be 2 bytes stored in Little Endian format.
    ///   - blockList: Block List represent in an array of Data objects. 2-Byte or 3-Byte block list element is supported.
    ///   - resultHandler: Completion handler called when the operation is completed. Valid read data blocks (block length of 16 bytes) are returned in an array of Data objects when Status Flag 1 equals zero.
    ///
    /// Read Without Encrypton command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    public func readWithoutEncryption(serviceCodeList: [Data], blockList: [Data], resultHandler: @escaping (Result<(FeliCaStatusFlag, [Data]), Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func readWithoutEncryption(serviceCodeList: [Data], blockList: [Data], completionHandler: @escaping (Int, Int, [Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    /// Sends the Write Without Encryption command, as defined by the FeliCa card specification, to the tag.
    /// - Parameters:
    ///   - serviceCodeList: Service Code list represented in an array of Data objects. Number of nodes specified should be between 1 to 16 inclusive. Each service code should be 2 bytes stored in Little Endian format.
    ///   - blockList: Block List represent in an array of Data objects. Total blockList items and blockData items should match. 2-Byte or 3-Byte block list element is supported.
    ///   - blockData: Block data represent in an array of Data objects. Total blockList items and blockData items should match. Data block should be 16 bytes in length.
    ///   - resultHandler: Returns `NFCFeliCaStatusFlag` or a `NFCErrorDomain` error when operation is completed.
    ///
    /// Write Without Encrypton command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    public func writeWithoutEncryption(serviceCodeList: [Data], blockList: [Data], blockData: [Data], resultHandler: @escaping (Result<FeliCaStatusFlag, Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func writeWithoutEncryption(serviceCodeList: [Data], blockList: [Data], blockData: [Data], completionHandler: @escaping (Int, Int, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    // MARK: - Requesting System Codes
    
    /// Sends the Request System Code command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns an array of system code as Data or a `NFCErrorDomain` error when the operation is completed. Each system code is 2 bytes stored in Little Endian format.
    ///
    /// Request System Code command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    public func requestSystemCode(resultHandler: @escaping (Result<[Data], Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestSystemCode(completionHandler: @escaping ([Data], Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    // MARK: - Requesting Specification Versions
    
    /// Sends the Request Specification Version command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns `NFCFeliCaRequestSpecificationVersionResponse` or a `NFCErrorDomain` error when the operation is completed.
    ///           `basicVersion` and `optionVersion` may be nil depending on the Status Flag 1 value and if the tag supports AES/DES.
    ///
    /// Request Specification Verison command defined by FeliCa card specification. This command supports response format version `00`h. Refer to the FeliCa specification for details.
    public func requestSpecificationVersion(resultHandler: @escaping (Result<FeliCaRequestSpecificationVersionResponse, Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func requestSpecificationVersion(completionHandler: @escaping (Int, Int, Data, Data, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
    // MARK: - Resetting Modes
    
    /// Sends the Reset Mode command, as defined by the FeliCa card specification, to the tag.
    /// - Parameter resultHandler: Returns `NFCFeliCaStatusFlag` or a `NFCErrorDomain` error when the operation is completed.
    ///
    /// Reset Mode command defined by FeliCa card specification. Refer to the FeliCa specification for details.
    public func resetMode(resultHandler: @escaping (Result<FeliCaStatusFlag, Error>) -> Void) {
        
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func resetMode(completionHandler: @escaping (Int, Int, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
    
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
