//
//  NFCKitISO7816Tag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

import NFCKitCore

#if canImport(CoreNFC)
@available(iOS 13.0, *)
extension CoreNFC.NFCISO7816Tag {
    
    // MARK: - sendCommand(apdu:)
    
    #if compiler(>=5.5) && canImport(_Concurrency)
    /// Sends an application protocol data unit (APDU) to the tag and receives a response APDU.
    /// - Parameter apdu: An application protocol data unit to send to the tag.
    /// - Returns: A Result with the cases:
    ///              success: A `NFCISO7816ResponseAPDU` object.
    ///              failure:
    ///                  payload: A data object that contains the response data.
    ///                  statusWord1: The SW1 command-processing status byte.
    ///                  statusWord2: The SW2 command-processing status byte.
    @available(iOS 15.0, *)
    func sendCommand(apdu: NFCISO7816APDU) async -> Result<(payload: Data, statusWord1: UInt8, statusWord2: UInt8), NFCReaderError> {
        do {
            let responseAPDU: (payload: Data, statusWord1: UInt8, statusWord2: UInt8) = try await sendCommand(apdu: apdu)
            return .success(responseAPDU)
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    #endif
    
    #if compiler(>=5.5) && canImport(_Concurrency)
    /// Sends an application protocol data unit (APDU) to the tag and receives a response APDU.
    /// - Parameter apdu: An application protocol data unit to send to the tag.
    /// - Returns: A Result with the cases:
    ///              success: A `NFCISO7816ResponseAPDU` object.
    ///              failure: An `NFCReaderError` object indicating that a communication issue with the tag occurred.
    @available(iOS 15.0, *)
    func sendCommand(apdu: NFCISO7816APDU) async -> Result<NFCISO7816ResponseAPDU, NFCReaderError> {
        do {
            let responseAPDU: NFCISO7816ResponseAPDU = try await sendCommand(apdu: apdu)
            return .success(responseAPDU)
        } catch {
            return .failure(error as! NFCReaderError)
        }
    }
    #endif
}
#endif
