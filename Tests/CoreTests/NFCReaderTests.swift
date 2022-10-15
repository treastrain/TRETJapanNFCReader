//
//  NFCReaderTests.swift
//  CoreTests
//
//  Created by treastrain on 2022/10/10.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core

final class NFCReaderTests: XCTestCase {
    /// `NFCReader.begin(sessionAndDelegate:detectingAlertMessage:)` を呼んだとき、`TagType.ReaderSession.readingAvailable` が `true` ならば `session` と `sessionDelegate` が `nil` ではなくなり、`session.alertMessage` に `String` が入り、`session.begin()` が1回呼ばれる
    func testNFCReaderBeginWhenTagTypeReaderSessionReadingAvailableIsTrue() async throws {
        #if canImport(CoreNFC)
        let session = NFCTestReaderSessionReadingAvailable()
        let delegate = NFCTestReaderSessionDelegate()
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<TestTag<NFCTestReaderSessionReadingAvailable>>()
        try await reader.begin(
            sessionAndDelegate: { (session, delegate) },
            detectingAlertMessage: alertMessage
        )
        
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession, session)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertIdentical(readerSessionDelegate, delegate)
        let readerSessionAlertMessage = readerSession.alertMessage
        XCTAssertEqual(readerSessionAlertMessage, alertMessage)
        let readerSessionBeginCallCount = readerSession.beginCallCount
        XCTAssertEqual(readerSessionBeginCallCount, 1)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    /// `NFCReader.begin(sessionAndDelegate:detectingAlertMessage:)` を呼んだとき、`TagType.ReaderSession.readingAvailable` が `false` ならば `NFCReaderError` が返ってくる
    func testNFCReaderBeginWhenTagTypeReaderSessionReadingAvailableIsFalse() async throws {
        #if canImport(CoreNFC)
        let session = NFCTestReaderSessionReadingUnavailable()
        let delegate = NFCTestReaderSessionDelegate()
        
        let reader = NFCReader<TestTag<NFCTestReaderSessionReadingUnavailable>>()
        do {
            try await reader.begin(
                sessionAndDelegate: { (session, delegate) },
                detectingAlertMessage: "Detecting Alert Message"
            )
            XCTFail("The `NFCReaderErrorUnsupportedFeature` is not thrown.")
        } catch {
            XCTAssertEqual((error as! NFCReaderError).code, .readerErrorUnsupportedFeature)
            let readerSession = await reader.sessionAndDelegate?.session
            XCTAssertNil(readerSession)
            let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
            XCTAssertNil(readerSessionDelegate)
        }
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC)
private enum TestTag<ReaderSession: NFCReaderSessionable>: NFCTagType {
    typealias ReaderSession = ReaderSession
    typealias ReaderSessionProtocol = Never
    typealias ReaderSessionDetectObject = Never
    typealias DetectResult = Never
}

private class NFCTestReaderSession: NSObject, NFCReaderSessionProtocol, @unchecked Sendable {
    typealias Session = NFCTestReaderSessionReadingAvailable
    typealias Delegate = NFCTestReaderSessionDelegate
    
    var delegate: AnyObject?
    let isReady = false
    var alertMessage = ""
    var beginCallCount = 0
    func begin() {
        beginCallCount += 1
    }
    func invalidate() {}
    func invalidate(errorMessage: String) {}
}

private final class NFCTestReaderSessionReadingAvailable: NFCTestReaderSession, NFCReaderSessionable {
    static let readingAvailable = true
}

private final class NFCTestReaderSessionReadingUnavailable: NFCTestReaderSession, NFCReaderSessionable {
    static let readingAvailable = false
}

private actor NFCTestReaderSessionDelegate: Actor {}
#endif
