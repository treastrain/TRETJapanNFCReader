//
//  ISO15693MultipleBlockSecurityStatusTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/02.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class ISO15693MultipleBlockSecurityStatusTests: XCTestCase, NFCKitTests {
    func testISO15693MultipleBlockSecurityStatus() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        let childValueHandler: ((Mirror.Child) -> AnyObject?) = { (child) -> AnyObject? in
            return (child.value as! [Int]).first as AnyObject
        }
        
        var core = NFCISO15693MultipleBlockSecurityStatus(blockSecurityStatus: [0])
        let kit = ISO15693MultipleBlockSecurityStatus(from: core)
        testObjectConsistency(core, kit, coreChildValueHandler: childValueHandler, kitChildValueHandler: childValueHandler)
        
        core = NFCISO15693MultipleBlockSecurityStatus(from: kit)
        testObjectConsistency(core, kit, coreChildValueHandler: childValueHandler, kitChildValueHandler: childValueHandler)
        #else
        _ = ISO15693MultipleBlockSecurityStatus(blockSecurityStatus: [0])
        #endif
    }
}
