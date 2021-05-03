//
//  FeliCaEncryptionIdTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/01.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class FeliCaEncryptionIdTests: XCTestCase, NFCKitTests {
    func testFeliCaEncryptionId() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 13.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        XCTAssertEqual(CoreNFC.NFCFeliCaEncryptionId.AES.rawValue, FeliCaEncryptionId.AES)
        XCTAssertEqual(CoreNFC.NFCFeliCaEncryptionId.AES_DES.rawValue, FeliCaEncryptionId.AES_DES)
        #endif
    }
}
