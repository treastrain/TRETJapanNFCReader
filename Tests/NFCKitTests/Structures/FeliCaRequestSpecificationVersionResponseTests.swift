//
//  FeliCaRequestSpecificationVersionResponseTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/02/23.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class FeliCaRequestSpecificationVersionResponseTests: XCTestCase, NFCKitTests {
    func testFeliCaRequestSpecificationVersionResponse() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        var core = NFCFeliCaRequestSpecificationVersionResponse(statusFlag1: 0, statusFlag2: 0, basicVersion: nil, optionVersion: nil)
        let kit = FeliCaRequestSpecificationVersionResponse(from: core)
        testObjectConsistency(core, kit)
        
        core = NFCFeliCaRequestSpecificationVersionResponse(from: kit)
        testObjectConsistency(core, kit)
        #else
        _ = FeliCaRequestSpecificationVersionResponse(statusFlag1: 0, statusFlag2: 0, basicVersion: nil, optionVersion: nil)
        #endif
    }
}

