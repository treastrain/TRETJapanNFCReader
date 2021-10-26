//
//  JapanIndividualNumberCardReaderTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/27.
//

import XCTest
@testable import JapanIndividualNumberCardReader

final class JapanIndividualNumberCardReaderTests: XCTestCase {
}

// MARK: - JapanIndividualNumberCardReader.convertToJISX0201(item:pinString:)
@available(iOS 13.0, *)
extension JapanIndividualNumberCardReaderTests {
    func testConvertToJISX0201ElectronicCertificateForTheBearersSignature() throws {
        let item = JapanIndividualNumberCardItem.electronicCertificateForTheBearersSignature
        
        do {
            let pinString = ""
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
        
        do {
            let pinString = "0123456789"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .success([0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39]))
        }
        
        do {
            let pinString = "ABCDEFGHIJKLMNOP"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .success([0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50]))
        }
        
        do {
            let pinString = "QRSTUVWXYZ"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .success([0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A]))
        }
        
        do {
            let pinString = "1234"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
        
        do {
            let pinString = "ABCD"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
        
        do {
            let pinString = "12AB"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
        
        do {
            let pinString = "あ"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
        
        do {
            let pinString = "01234567890ABCDEF"
            let result = JapanIndividualNumberCardReader.convertToJISX0201(item: item, pinString: pinString)
            XCTAssertEqual(result, .failure(.notStartedScanBecausePINFormatInvalid))
        }
    }
}
