//
//  NFCVASReaderTests.swift
//  CoreTests
//
//  Created by treastrain on 2023/04/16.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core

final class NFCVASReaderTests: XCTestCase {
    func testConformingNFCVASReaderSession() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCVASReader.Session.self, NFCVASReaderSession.self)
        XCTAssertIdentical((any NFCVASReader.Delegate).self as AnyObject, (any NFCVASReaderSessionDelegate).self as AnyObject)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}
