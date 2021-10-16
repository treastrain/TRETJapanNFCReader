//
//  NFCKitISO15693Tag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/16.
//

import NFCKitCore

#if canImport(CoreNFC)
@available(iOS 11.0, *)
extension CoreNFC.NFCISO15693Tag {
    
    // MARK: - sendCustomCommand(commandConfiguration:)
    
    /// Send a manufacturer dependent custom command using command code range from 0xA0 to 0xDF.  Refer to ISO15693-3 specification for details.
    /// - Parameters:
    ///   - commandConfiguration: Configuration for the Manufacturer Custom Command.
    ///   - resultHandler: Result handler called when the operation is completed. A NFCISO15693TagResponseErrorKey in NSError userInfo dictionary is returned when the tag responded to the command with an error, and the error code value is defined in ISO15693-3 specification.
    @available(iOS 11.0, *)
    public func sendCustomCommand(commandConfiguration: NFCISO15693CustomCommandConfiguration, resultHandler: @escaping ((Result<Data, NFCReaderError>)) -> Void) {
        sendCustomCommand(commandConfiguration: commandConfiguration, completionHandler: { data, error in
            if let error = error {
                resultHandler(.failure(error as! NFCReaderError))
            } else {
                resultHandler(.success(data))
            }
        })
    }
    
    /// Send a manufacturer dependent custom command using command code range from 0xA0 to 0xDF.  Refer to ISO15693-3 specification for details.
    /// - Parameter commandConfiguration: Configuration for the Manufacturer Custom Command.
    /// - Returns: A data.
    @available(iOS 15.0, *)
    public func sendCustomCommand(commandConfiguration: NFCISO15693CustomCommandConfiguration) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            sendCustomCommand(commandConfiguration: commandConfiguration) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Send a manufacturer dependent custom command using command code range from 0xA0 to 0xDF.  Refer to ISO15693-3 specification for details.
    /// - Parameter commandConfiguration: Configuration for the Manufacturer Custom Command.
    /// - Returns: A Result with the cases:
    ///              success: A data.
    ///              failure: An `NFCReaderError` object. A NFCISO15693TagResponseErrorKey in NSError userInfo dictionary is returned when the tag responded to the command with an error, and the error code value is defined in ISO15693-3 specification.
    @available(iOS 15.0, *)
    public func sendCustomCommand(commandConfiguration: NFCISO15693CustomCommandConfiguration) async -> Result<Data, NFCReaderError> {
        do {
            let data: Data = try await sendCustomCommand(commandConfiguration: commandConfiguration)
            return .success(data)
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    
    
    // MARK: - readMultipleBlock(readConfiguration:)
    
    /// Performs read operation using Read Multiple Blocks command (0x23 command code) as defined in ISO15693-3 specification. Multiple Read Multiple Blocks commands will be sent if necessary to complete the operation.
    /// - Parameters:
    ///   - readConfiguration: Configuration For the Read Multiple Blocks command.
    ///   - resultHandler: Result handler called when the operation is completed. A NFCISO15693TagResponseErrorKey in NSError userInfo dictionary is returned when the tag responded to the command with an error, and the error code value is defined in ISO15693-3 specification. Successfully read data blocks will be returned from NSData object.  All blocks are concatenated into the NSData object.
    @available(iOS 11.0, *)
    public func readMultipleBlock(readConfiguration: NFCISO15693ReadMultipleBlocksConfiguration, resultHandler: @escaping ((Result<Data, NFCReaderError>)) -> Void) {
        readMultipleBlock(readConfiguration: readConfiguration, completionHandler: { data, error in
            if let error = error {
                resultHandler(.failure(error as! NFCReaderError))
            } else {
                resultHandler(.success(data))
            }
        })
    }
    
    /// Performs read operation using Read Multiple Blocks command (0x23 command code) as defined in ISO15693-3 specification. Multiple Read Multiple Blocks commands will be sent if necessary to complete the operation.
    /// - Parameter readConfiguration: Configuration For the Read Multiple Blocks command.
    /// - Returns: Read data blocks will be returned from NSData object.  All blocks are concatenated into the NSData object.
    @available(iOS 15.0, *)
    public func readMultipleBlock(readConfiguration: NFCISO15693ReadMultipleBlocksConfiguration) async throws -> Data {
        try await withCheckedThrowingContinuation{ continuation in
            readMultipleBlock(readConfiguration: readConfiguration) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Performs read operation using Read Multiple Blocks command (0x23 command code) as defined in ISO15693-3 specification. Multiple Read Multiple Blocks commands will be sent if necessary to complete the operation.
    /// - Parameter readConfiguration: Configuration For the Read Multiple Blocks command.
    /// - Returns: Read data blocks will be returned from NSData object.  All blocks are concatenated into the NSData object.
    @available(iOS 15.0, *)
    public func readMultipleBlock(readConfiguration: NFCISO15693ReadMultipleBlocksConfiguration) async -> Result<Data, NFCReaderError> {
        do {
            let data: Data = try await readMultipleBlock(readConfiguration: readConfiguration)
            return .success(data)
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    
    
    // MARK: - stayQuiet()
    
    /// Sends a Stay Quiet command (0x02 command code), as defined in the ISO 15693-3 specification, to the tag.
    /// - Parameters:
    ///   - resultHandler: A handler that the reader session invokes after the operation completes. The handler receives a Result with the cases:
    ///   - success: A `Void`.
    ///   - failure: An `NFCReaderError` is returned when there is a communication issue with the tag. A NFCISO15693TagResponseErrorKey in NSError userInfo dictionary is returned when the tag responded to the command with an error, and the error code value is defined in ISO15693-3 specification.
    @available(iOS 13.0, *)
    public func stayQuiet(resultHandler: @escaping ((Result<Void, NFCReaderError>)) -> Void) {
        stayQuiet(completionHandler: { error in
            if let error = error {
                resultHandler(.failure(error as! NFCReaderError))
            } else {
                resultHandler(.success(()))
            }
        })
    }
    
    /// Sends a Stay Quiet command (0x02 command code), as defined in the ISO 15693-3 specification, to the tag.
    /// - Returns: A Result with the cases:
    ///              success: A `Void`.
    ///              failure: An `NFCReaderError` is returned when there is a communication issue with the tag. A NFCISO15693TagResponseErrorKey in NSError userInfo dictionary is returned when the tag responded to the command with an error, and the error code value is defined in ISO15693-3 specification.
    @available(iOS 15.0, *)
    public func stayQuiet() async -> Result<Void, NFCReaderError> {
        do {
            let _: Void = try await stayQuiet()
            return .success(())
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    
    
    // MARK: - readSingleBlock(requestFlags:blockNumber:)
    
    /// Sends a Read Single Block command (0x20 command code), as defined in the ISO 15693-3 specification, to the tag.
    /// - Parameters:
    ///   - flags: The request flags. The RequestFlagAddress flag is enforced by default. However, using the RequestFlagSelect flag disables the RequestFlagAddress flag.
    ///   - blockNumber: The number of the block to read. Blocks are numbered from 0 to 255 inclusively.
    /// - Returns: A Result with the cases:
    ///              success: A `Data` object containing the blocks of data read from the tag. If the request flags include RequestFlagOption, the first byte of the data contains the associated block security status.
    ///              failure: An `NFCReaderError` is returned when there is a problem occurred while communicating with the tag. When the tag responds with a command error, the error's userInfo directory contains the NFCISO15693TagResponseErrorKey and the error's code property has a value defined in the ISO15693-3 specification.
    @available(iOS 15.0, *)
    public func readSingleBlock(requestFlags flags: NFCISO15693RequestFlag, blockNumber: UInt8) async -> Result<Data, NFCReaderError> {
        do {
            let data = try await readSingleBlock(requestFlags: flags, blockNumber: blockNumber)
            return .success(data)
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    
    
    // MARK: - writeSingleBlock(requestFlags:blockNumber:dataBlock:)
    
    // MARK: - lockBlock(requestFlags:blockNumber:)
    
    // MARK: - readMultipleBlocks(requestFlags:blockRange:)
    
    // MARK: - writeMultipleBlocks(requestFlags:blockRange:dataBlocks:)
    
    // MARK: - select(requestFlags:)
    
    // MARK: - resetToReady(requestFlags:)
    
    // MARK: - writeAFI(requestFlags:afi:)
    
    // MARK: - lockAFI(requestFlags:)
    
    // MARK: - writeDSFID(requestFlags:dsfid:)
    
    // MARK: - lockDSFID(requestFlags:)
    
    // MARK: - getSystemInfo(requestFlags:)
    
    // MARK: - getMultipleBlockSecurityStatus(requestFlags:blockRange:)
    
    // MARK: - customCommand(requestFlags:customCommandCode:customRequestParameters:)
    
    // MARK: - extendedReadSingleBlock(requestFlags:blockNumber:)
    
    // MARK: - extendedWriteSingleBlock(requestFlags:blockNumber:dataBlock:)
    
    // MARK: - extendedLockBlock(requestFlags:blockNumber:)
    
    // MARK: - extendedReadMultipleBlocks(requestFlags:blockRange:)
    
    // MARK: - systemInfo(requestFlags:)
    
    // MARK: - fastReadMultipleBlocks(requestFlags:blockRange:)
    
    // MARK: - extendedWriteMultipleBlocks(requestFlags:blockRange:dataBlocks:)
    
    // MARK: - authenticate(requestFlags:cryptoSuiteIdentifier:message:)
    
    // MARK: - keyUpdate(requestFlags:keyIdentifier:message:)
    
    // MARK: - challenge(requestFlags:cryptoSuiteIdentifier:message:)
    
    // MARK: - readBuffer(requestFlags:)
    
    // MARK: - extendedGetMultipleBlockSecurityStatus(requestFlags:blockRange:)
    
    // MARK: - extendedFastReadMultipleBlocks(requestFlags:blockRange:)
    
    // MARK: - sendRequest(requestFlags:commandCode:data:)
}
#endif

