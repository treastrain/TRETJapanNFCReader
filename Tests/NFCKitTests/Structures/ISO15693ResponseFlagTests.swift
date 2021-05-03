//
//  ISO15693ResponseFlagTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class ISO15693ResponseFlagTests: XCTestCase, NFCKitTests {
    func testISO15693ResponseFlag() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.error.rawValue, ISO15693ResponseFlag.error.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.responseBufferValid.rawValue, ISO15693ResponseFlag.responseBufferValid.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.finalResponse.rawValue, ISO15693ResponseFlag.finalResponse.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.protocolExtension.rawValue, ISO15693ResponseFlag.protocolExtension.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.blockSecurityStatusBit5.rawValue, ISO15693ResponseFlag.blockSecurityStatusBit5.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.blockSecurityStatusBit6.rawValue, ISO15693ResponseFlag.blockSecurityStatusBit6.rawValue)
        XCTAssertEqual(CoreNFC.NFCISO15693ResponseFlag.waitTimeExtension.rawValue, ISO15693ResponseFlag.waitTimeExtension.rawValue)
        
        for kit in ISO15693ResponseFlag.allCases {
            let core = CoreNFC.NFCISO15693ResponseFlag(from: kit)
            testObjectConsistency(core, kit)
            
            let kit = ISO15693ResponseFlag(from: core)
            testObjectConsistency(core, kit)
        }
        #endif
    }
}
