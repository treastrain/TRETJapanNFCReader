//
//  NDEFPayload.swift
//  
//
//  Created by treastrain on 2021/05/17.
//

import Foundation

public struct NDEFPayload {
    /// The Type Name Format field of the payload, as defined by the NDEF specification.
    public var typeNameFormat: TypeNameFormat
    /// The type of the payload, as defined by the NDEF specification.
    public var type: Data
    /// The identifier of the payload, as defined by the NDEF specification.
    public var identifier: Data
    /// The payload, as defined by the NDEF specification.
    public var payload: Data
    
    /// Creates a payload record with a URI specified as a URL.
    /// - Parameter url: A URL object.
    /// - Returns: An NDEF payload record.
    @available(*, unavailable, message: "This method is not yet implemented.")
    public static func wellKnownTypeURIPayload(url: URL) -> Self? {
        return nil
    }
    
    /// Creates a payload record with a URI specified as a string.
    /// - Parameter uri: A URL string.
    /// - Returns: An NDEF payload record.
    ///
    /// Use this method to create NDEF URI payload records that you can't create using a URL object, such as a URI containing special characters not represented by 7-bit ASCII encoding such as ä and ö.
    @available(*, unavailable, message: "This method is not yet implemented.")
    public static func wellKnownTypeURIPayload(string uri: String) -> Self? {
        return nil
    }
    
    /// Creates a payload record with text.
    /// - Parameters:
    ///   - text: Text to include in the payload.
    ///   - locale: A locale object. This method saves the IANA language code, specified by the locale, to the payload.
    /// - Returns: An NDEF payload record.
    @available(*, unavailable, message: "This method is not yet implemented.")
    public static func wellKnownTypeTextPayload(string text: String, locale: Locale) -> Self? {
        return nil
    }
    
    /// Creates a payload record with the specified format, type, identifier, and payload data.
    /// - Parameters:
    ///   - format: A NFC type name format value.
    ///   - type: A data object describing the type of payload. If the data is empty, the method excludes this field from the payload record.
    ///   - identifier: A URI reference that identifies the payload. If the data is empty, the method excludes this field from the payload record.
    ///   - payload: A data object containing the payload data. If the data is empty, the method excludes this field from the payload record.
    ///
    /// This initializer uses the maximum payload chunk size defined by the NFC NDEF specification, which is 2^32-1 octets. If the payload size is bigger than the maximum size, the initializer splits the record into multiple record chunks.
    public init(format: TypeNameFormat, type: Data, identifier: Data, payload: Data) {
        self.typeNameFormat = format
        self.type = type
        self.identifier = identifier
        self.payload = payload
    }
    
    /// Creates a payload record with the specified format, type, identifier, payload data, and data chunk size.
    /// - Parameters:
    ///   - format: A NFC type name format value.
    ///   - type: A data object describing the type of payload. If the data is empty, the method excludes this field from the payload record.
    ///   - identifier: A URI reference that identifies the payload. If the data is empty, the method excludes this field from the payload record.
    ///   - payload: A data object containing the payload data. If the data is empty, the method excludes this field from the payload record.
    ///   - chunkSize: The maximum size of a payload chunk. A value of zero indicates that the payload fits in a single record, that is, no chunking of the payload.
    @available(*, unavailable, message: "This initializer is not yet implemented.")
    public init(format: TypeNameFormat, type: Data, identifier: Data, payload: Data, chunkSize: Int) {
        self.typeNameFormat = format
        self.type = type
        self.identifier = identifier
        self.payload = payload
        // chunkSize
    }
    
    /// Returns the text and locale of a valid Well Known Type Text payload.
    /// - Returns: A tuple containing a string and locale from a Well Known Type Text payload. The string and locale can be `nil`.
    @available(*, unavailable, message: "This method is not yet implemented.")
    public func wellKnownTypeTextPayload() -> (String?, Locale?) {
        return (nil, nil)
    }
    
    /// Returns the URL of a valid Well Known Type URI payload.
    /// - Returns: A URL when the payload contains a Well Know Type URI; otherwise, `nil`.
    @available(*, unavailable, message: "This method is not yet implemented.")
    public func wellKnownTypeURIPayload() -> URL? {
        return nil
    }
}
