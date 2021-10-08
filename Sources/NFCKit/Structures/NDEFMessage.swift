//
//  NDEFMessage.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct NDEFMessage {
    /// An array of records for the message.
    public let records: [NDEFPayload]
    
    /// The length, in bytes, of the NDEF message when stored on an NFC tag.
    ///
    /// The maximum length of an NDEF message is 128 KB.
    public let length: Int
    
    /// Creates an NDEF message with the specified records.
    /// - Parameter records: An array of payload objects for the message. To create an empty message, pass in an empty array.
    @available(*, unavailable, message: "This initializer is not yet implemented.")
    public init(records: [NDEFPayload]) {
        self.records = records
        self.length = 0
    }
    
    /// Creates an NDEF message from raw data representing the message.
    /// - Parameter data: A data object containing the raw bytes of a complete NDEF message. The data must contain only one NDEF message, and the message must contain NDEF payloads that are valid according to the NFC Forum NDEF RTD specification.
    @available(*, unavailable, message: "This initializer is not yet implemented.")
    public init?(data: Data) {
        self.records = []
        self.length = 0
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    public init(from coreNFCInstance: CoreNFC.NFCNDEFMessage) {
        self.records = .init(from: coreNFCInstance.records)
        self.length = coreNFCInstance.length
    }
    #endif
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 11.0, *)
extension CoreNFC.NFCNDEFMessage {
    @available(iOS 13.0, *)
    public convenience init(from nfcKitInstance: NDEFMessage) {
        self.init(records: .init(from: nfcKitInstance.records))
    }
}
#endif
