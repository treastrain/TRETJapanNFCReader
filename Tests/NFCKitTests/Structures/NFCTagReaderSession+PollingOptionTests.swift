//
//  NFCTagReaderSession+PollingOptionTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/08.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class NFCTagReaderSessionPollingOptionTests: XCTestCase, NFCKitTests {
    func testNFCTagReaderSessionPollingOption() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 13.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        XCTAssertEqual(CoreNFC.NFCTagReaderSession.PollingOption.iso14443.rawValue, NFCKit.NFCTagReaderSession.PollingOption.iso14443.rawValue)
        XCTAssertEqual(CoreNFC.NFCTagReaderSession.PollingOption.iso15693.rawValue, NFCKit.NFCTagReaderSession.PollingOption.iso15693.rawValue)
        XCTAssertEqual(CoreNFC.NFCTagReaderSession.PollingOption.iso18092.rawValue, NFCKit.NFCTagReaderSession.PollingOption.iso18092.rawValue)
        
        for kit in NFCTagReaderSession.PollingOption.allCases {
            let core = CoreNFC.NFCTagReaderSession.PollingOption(from: kit)
            testObjectConsistency(core, kit)
            
            let kit = NFCKit.NFCTagReaderSession.PollingOption(from: core)
            testObjectConsistency(core, kit)
        }
        #endif
    }
}
