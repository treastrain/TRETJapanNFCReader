//
//  FeliCaPollingResponseTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/02/23.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class FeliCaPollingResponseTests: XCTestCase, NFCKitTests {
    func testFeliCaPollingResponse() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        var core = NFCFeliCaPollingResponse(manufactureParameter: Data(), requestData: nil)
        let kit = FeliCaPollingResponse(from: core)
        testObjectConsistency(core, kit)
        
        core = NFCFeliCaPollingResponse(from: kit)
        testObjectConsistency(core, kit)
        #else
        _ = FeliCaPollingResponse(manufactureParameter: Data(), requestData: nil)
        #endif
    }
}
