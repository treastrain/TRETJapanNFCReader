//
//  ISO15693RequestFlagTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class ISO15693RequestFlagTests: XCTestCase, NFCKitTests {
    func testISO15693RequestFlag() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.dualSubCarriers.rawValue, ISO15693RequestFlag.dualSubCarriers.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.highDataRate.rawValue, ISO15693RequestFlag.highDataRate.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.protocolExtension.rawValue, ISO15693RequestFlag.protocolExtension.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.select.rawValue, ISO15693RequestFlag.select.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.address.rawValue, ISO15693RequestFlag.address.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.option.rawValue, ISO15693RequestFlag.option.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693RequestFlag.commandSpecificBit8.rawValue, ISO15693RequestFlag.commandSpecificBit8.rawValue)
        
        for kit in ISO15693RequestFlag.allCases {
            let core = CoreNFC.NFCISO15693RequestFlag(from: kit)
            testObjectConsistency(core, kit)
            
            let kit = ISO15693RequestFlag(from: core)
            testObjectConsistency(core, kit)
        }
        #endif
    }
}
