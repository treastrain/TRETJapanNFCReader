//
//  NDEFPayload+TypeNameFormat.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/17.
//

import Foundation

extension NDEFPayload {
    /// The Type Name Format values that specify the content type for the payload data in an NFC NDEF message.
    public enum TypeNameFormat: UInt8 {
        /// A type indicating that the payload contains no data.
        case empty = 0
        /// A type indicating that the payload contains well-known NFC record type data.
        case nfcWellKnown = 1
        /// A type indicating that the payload contains media data as defined by RFC 2046.
        case media = 2
        /// A type indicating that the payload contains a uniform resource identifier.
        case absoluteURI = 3
        /// A type indicating that the payload contains NFC external type data.
        case nfcExternal = 4
        /// A type indicating that the payload data type is unknown.
        case unknown = 5
        /// A type indicating that the payload is part of a series of records containing chunked data.
        case unchanged = 6
    }
}
