//
//  ISO15693SystemInfoTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/04/27.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class ISO15693SystemInfoTests: XCTestCase, NFCKitTests {
    func testISO15693SystemInfoTests() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        var core = NFCISO15693SystemInfo(uniqueIdentifier: Data(), dataStorageFormatIdentifier: 0, applicationFamilyIdentifier: 1, blockSize: 2, totalBlocks: 3, icReference: 4)
        let kit = ISO15693SystemInfo(from: core)
        testObjectConsistency(core, kit)
        
        core = NFCISO15693SystemInfo(from: kit)
        testObjectConsistency(core, kit)
        #else
        _ = ISO15693SystemInfo(uniqueIdentifier: Data(), dataStorageFormatIdentifier: 0, applicationFamilyIdentifier: 0, blockSize: 0, totalBlocks: 0, icReference: 0)
        #endif
    }
}
