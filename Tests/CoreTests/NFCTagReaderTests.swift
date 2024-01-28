//
//  NFCTagReaderTests.swift
//  CoreTests
//
//  Created by treastrain on 2023/04/16.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core

final class NFCTagReaderTests: XCTestCase {
    func testConformingNFCTagReaderSession() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCTagReader.Session.self, NFCTagReaderSession.self)
        XCTAssertEqual(String(describing: (any NFCTagReader.Delegate).self), String(describing: (any NFCTagReaderSessionDelegate).self)) // XCTAssertIdentical((any NFCTagReader.Delegate).self as AnyObject, (any NFCTagReaderSessionDelegate).self as AnyObject) // TODO: wait fixing https://gist.github.com/treastrain/6e9358d3e715720568004d99aabb25fc
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}
