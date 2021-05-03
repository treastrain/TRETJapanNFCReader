//
//  FeliCaStatusFlagTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/02.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class FeliCaStatusFlagTests: XCTestCase, NFCKitTests {
    func testFeliCaStatusFlag() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        var core = NFCFeliCaStatusFlag(statusFlag1: 1, statusFlag2: 2)
        let kit = FeliCaStatusFlag(from: core)
        testObjectConsistency(core, kit)
        
        core = NFCFeliCaStatusFlag(from: kit)
        testObjectConsistency(core, kit)
        #else
        _ = FeliCaStatusFlag(statusFlag1: 1, statusFlag2: 2)
        #endif
    }
}
