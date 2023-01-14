//
//  InfoPListKey+Extension.swift
//  InfoPListChecker
//
//  Created by treastrain on 2022/11/26.
//

import Foundation

extension InfoPListKey<String, Never> {
    /// [NFCReaderUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nfcreaderusagedescription)
    public static let nfcReaderUsageDescription: Self = .init(
        key: "NFCReaderUsageDescription",
        name: "Privacy - NFC Scan Usage Description"
    )
}

extension InfoPListKey<[String], Never> {
    /// [com.apple.developer.nfc.readersession.felica.systemcodes](https://developer.apple.com/documentation/bundleresources/information_property_list/systemcodes)
    public static let systemcodes: Self = .init(
        key: "com.apple.developer.nfc.readersession.felica.systemcodes",
        name: "ISO18092 system codes for NFC Tag Reader Session"
    )
    
    /// [com.apple.developer.nfc.readersession.iso7816.select-identifiers](https://developer.apple.com/documentation/bundleresources/information_property_list/select-identifiers)
    public static let selectIdentifiers: Self = .init(
        key: "com.apple.developer.nfc.readersession.iso7816.select-identifiers",
        name: "ISO7816 application identifiers for NFC Tag Reader Session"
    )
}

extension InfoPListKey<[String], String> {
    /// [Near Field Communication Tag Reader Session Formats Entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_nfc_readersession_formats)
    public static let comAppleDeveloperNFCReadersessionFormats: Self = .init(
        key: "com.apple.developer.nfc.readersession.formats",
        name: "Near Field Communication Tag Reader Session Formats Entitlement",
        possibleValues: [
            .init(value: "NDEF", name: "NFC Data Exchange Format"),
            .init(value: "TAG", name: "Tag-Specific Data Protocol"),
            .init(value: "PACE", name: "Password Authenticated Connection Establishment"),
        ]
    )
}
