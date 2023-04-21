//
//  NFCNDEFReaderTests.swift
//  CoreTests
//
//  Created by treastrain on 2023/04/16.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core

final class NFCNDEFReaderTests: XCTestCase {
    func testConformingNFCNDEFReaderSession() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCNDEFReader.Session.self, NFCNDEFReaderSession.self)
        XCTAssertIdentical((any NFCNDEFReader.Delegate).self as AnyObject, (any NFCNDEFReaderSessionDelegate).self as AnyObject)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}
