//
//  NDEFPayload.swift
//  
//
//  Created by treastrain on 2021/05/17.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct NDEFPayload {
    #if os(iOS) && !targetEnvironment(macCatalyst)
    /// The Type Name Format field of the payload, as defined by the NDEF specification.
    @available(iOS 11.0, *)
    public var typeNameFormat: TypeNameFormat {
        get {
            TypeNameFormat(from: self.core.typeNameFormat)!
        }
        set {
            self.core.typeNameFormat = .init(from: newValue)
        }
    }
    
    /// The type of the payload, as defined by the NDEF specification.
    @available(iOS 11.0, *)
    public var type: Data {
        get {
            self.core.type
        }
        set {
            self.core.type = newValue
        }
    }
    
    /// The identifier of the payload, as defined by the NDEF specification.
    @available(iOS 11.0, *)
    public var identifier: Data {
        get {
            self.core.identifier
        }
        set {
            self.core.identifier = newValue
        }
    }
    
    /// The payload, as defined by the NDEF specification.
    @available(iOS 11.0, *)
    public var payload: Data {
        get {
            self.core.payload
        }
        set {
            self.core.payload = newValue
        }
    }
    
    /// Creates a payload record with a URI specified as a URL.
    /// - Parameter url: A URL object.
    /// - Returns: An NDEF payload record.
    @available(iOS 13.0, *)
    public static func wellKnownTypeURIPayload(url: URL) -> Self? {
        guard let core = CoreNFC.NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            return nil
        }
        return Self.init(from: core)
    }
    
    /// Creates a payload record with a URI specified as a string.
    /// - Parameter uri: A URL string.
    /// - Returns: An NDEF payload record.
    ///
    /// Use this method to create NDEF URI payload records that you can't create using a URL object, such as a URI containing special characters not represented by 7-bit ASCII encoding such as ä and ö.
    @available(iOS 13.0, *)
    public static func wellKnownTypeURIPayload(string uri: String) -> Self? {
        guard let core = CoreNFC.NFCNDEFPayload.wellKnownTypeURIPayload(string: uri) else {
            return nil
        }
        return Self.init(from: core)
    }
    
    /// Creates a payload record with text.
    /// - Parameters:
    ///   - text: Text to include in the payload.
    ///   - locale: A locale object. This method saves the IANA language code, specified by the locale, to the payload.
    /// - Returns: An NDEF payload record.
    @available(iOS 13.0, *)
    public static func wellKnownTypeTextPayload(string text: String, locale: Locale) -> Self? {
        guard let core = CoreNFC.NFCNDEFPayload.wellKnownTypeTextPayload(string: text, locale: locale) else {
            return nil
        }
        return Self.init(from: core)
    }
    
    /// Creates a payload record with the specified format, type, identifier, and payload data.
    /// - Parameters:
    ///   - format: A NFC type name format value.
    ///   - type: A data object describing the type of payload. If the data is empty, the method excludes this field from the payload record.
    ///   - identifier: A URI reference that identifies the payload. If the data is empty, the method excludes this field from the payload record.
    ///   - payload: A data object containing the payload data. If the data is empty, the method excludes this field from the payload record.
    ///
    /// This initializer uses the maximum payload chunk size defined by the NFC NDEF specification, which is 2^32-1 octets. If the payload size is bigger than the maximum size, the initializer splits the record into multiple record chunks.
    @available(iOS 13.0, *)
    public init(format: TypeNameFormat, type: Data, identifier: Data, payload: Data) {
        self.core = CoreNFC.NFCNDEFPayload(format: CoreNFC.NFCTypeNameFormat(rawValue: format.rawValue)!, type: type, identifier: identifier, payload: payload)
    }
    
    /// Creates a payload record with the specified format, type, identifier, payload data, and data chunk size.
    /// - Parameters:
    ///   - format: A NFC type name format value.
    ///   - type: A data object describing the type of payload. If the data is empty, the method excludes this field from the payload record.
    ///   - identifier: A URI reference that identifies the payload. If the data is empty, the method excludes this field from the payload record.
    ///   - payload: A data object containing the payload data. If the data is empty, the method excludes this field from the payload record.
    ///   - chunkSize: The maximum size of a payload chunk. A value of zero indicates that the payload fits in a single record, that is, no chunking of the payload.
    @available(iOS 13.0, *)
    public init(format: TypeNameFormat, type: Data, identifier: Data, payload: Data, chunkSize: Int) {
        self.core = CoreNFC.NFCNDEFPayload(format: CoreNFC.NFCTypeNameFormat(rawValue: format.rawValue)!, type: type, identifier: identifier, payload: payload, chunkSize: chunkSize)
    }
    
    /// Returns the text and locale of a valid Well Known Type Text payload.
    /// - Returns: A tuple containing a string and locale from a Well Known Type Text payload. The string and locale can be `nil`.
    @available(iOS 13.0, *)
    public func wellKnownTypeTextPayload() -> (String?, Locale?) {
        return self.core.wellKnownTypeTextPayload()
    }
    
    /// Returns the URL of a valid Well Known Type URI payload.
    /// - Returns: A URL when the payload contains a Well Know Type URI; otherwise, `nil`.
    @available(iOS 13.0, *)
    public func wellKnownTypeURIPayload() -> URL? {
        return self.core.wellKnownTypeURIPayload()
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    private var _core: Any?
    @available(iOS 11.0, *)
    internal var core: CoreNFC.NFCNDEFPayload {
        get {
            return self._core as! CoreNFC.NFCNDEFPayload
        }
        set {
            self._core = newValue
        }
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    internal init(from core: CoreNFC.NFCNDEFPayload) {
        self.core = core
    }
    #endif
}

#if os(iOS) && !targetEnvironment(macCatalyst)
@available(iOS 11.0, *)
public extension Array where Element == CoreNFC.NFCNDEFPayload {
    init(from nfcKitInstances: [NDEFPayload]) {
        self = nfcKitInstances.map { $0.core }
    }
}

public extension Array where Element == NDEFPayload {
    @available(iOS 13.0, *)
    init(from coreNFCInstances: [CoreNFC.NFCNDEFPayload]) {
        self = coreNFCInstances.map { .init(from: $0) }
    }
}
#endif
