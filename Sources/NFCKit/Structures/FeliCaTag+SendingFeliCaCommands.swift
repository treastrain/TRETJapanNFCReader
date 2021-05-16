//
//  FeliCaTag+SendingFeliCaCommands.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

extension FeliCaTag {
    // MARK: - Sending FeliCa Commands
    
    /// Sends the FeliCa command packet data to the tag.
    /// - Parameters:
    ///   - commandPacket: Command packet send to the FeliCa card. Maximum packet length is 254. Data length (LEN) byte and CRC bytes are calculated and inserted automatically to the provided packet data frame.
    ///   - resultHandler: Completion handler called when the operation is completed. A `NFCErrorDomain` error is returned when there is a communication issue with the tag.
    ///
    /// Transmission of FeliCa Command Packet Data at the applicaiton layer. Refer to the FeliCa specification for details. Manufacturer ID (IDm) of the currently selected system can be read from the currentIDm property.
    @available(iOS 13.0, *) @available(watchOS, unavailable) @available(tvOS, unavailable) @available(macOS, unavailable) @available(macCatalyst, unavailable)
    public func sendFeliCaCommand(commandPacket: Data, resultHandler: @escaping (Result<Data, Error>) -> Void) {
        if #available(iOS 14.0, *) {
            self.core.sendFeliCaCommand(commandPacket: commandPacket, resultHandler: resultHandler)
        } else {
            self.core.sendFeliCaCommand(commandPacket: commandPacket) { data, error in
                if let error = error {
                    resultHandler(.failure(error))
                } else {
                    resultHandler(.success(data))
                }
            }
        }
    }
    
    @available(*, unavailable, message: "Use the one using resultHander.")
    public func sendFeliCaCommand(commandPacket: Data, completionHandler: @escaping (Data, Error?) -> Void) {
        fatalError("\(#function): Use the one using resultHander.")
    }
}
