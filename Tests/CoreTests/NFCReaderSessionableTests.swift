//
//  NFCReaderSessionableTests.swift
//  CoreTests
//
//  Created by treastrain on 2022/10/10.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core

final class NFCReaderSessionableTests: XCTestCase {
    func testNFCNDEFReaderSessionConformsToNFCReaderSessionable() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCNDEFReaderSession.Session.self, NFCNDEFReaderSession.self)
        XCTAssertIdentical(NFCNDEFReaderSession.Delegate.self as AnyObject, NFCNDEFReaderSessionDelegate.self as AnyObject)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    func testNFCTagReaderSessionConformsToNFCReaderSessionable() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCTagReaderSession.Session.self, NFCTagReaderSession.self)
        XCTAssertEqual(String(describing: NFCTagReaderSession.Delegate.self), String(describing: NFCTagReaderSessionDelegate.self)) // XCTAssertIdentical(NFCTagReaderSession.Delegate.self as AnyObject, NFCTagReaderSessionDelegate.self as AnyObject) // TODO: wait fixing https://gist.github.com/treastrain/6e9358d3e715720568004d99aabb25fc
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    func testNFCVASReaderSessionConformsToNFCReaderSessionable() throws {
        #if canImport(CoreNFC)
        XCTAssertIdentical(NFCVASReaderSession.Session.self, NFCVASReaderSession.self)
        XCTAssertIdentical(NFCVASReaderSession.Delegate.self as AnyObject, NFCVASReaderSessionDelegate.self as AnyObject)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}
