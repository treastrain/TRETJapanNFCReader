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
@testable import TRETNFCKit_AssertServices

final class NFCReaderTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        AssertServices.assertionFailureHandler = { _, _, _ in }
    }
    
    override class func tearDown() {
        super.tearDown()
        AssertServices.assertionFailureHandler = AssertServices.assertionFailureDefaultHandler
    }
    
    /// `NFCReader.begin(readerAndDelegate:detectingAlertMessage:)` を呼んだとき、`TagType.Reader.Session.readingAvailable` が `true` ならば `reader` と `delegate` が `nil` ではなくなり、`reader.alertMessage` に `String` が入り、`reader.begin()` が1回呼ばれる
    func testNFCReaderBeginWhenTagTypeReaderReadingAvailableIsTrue() async throws {
        #if canImport(CoreNFC)
        let tagReader = NFCTestReaderReadingAvailable()
        let delegate = NFCTestReaderSessionReadingAvailable()
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<TestTag<NFCTestReaderReadingAvailable>>()
        try await reader.begin(
            readerAndDelegate: { (tagReader, delegate) },
            detectingAlertMessage: alertMessage
        )
        
        let tagReaderOrNil = await reader.readerAndDelegate?.reader
        XCTAssertIdentical(tagReaderOrNil, tagReader)
        let tagReaderDelegateOrNil = await reader.readerAndDelegate?.delegate
        XCTAssertIdentical(tagReaderDelegateOrNil, delegate)
        let tagReaderAlertMessage = await tagReaderOrNil?.alertMessage
        XCTAssertEqual(tagReaderAlertMessage, alertMessage)
        let tagReaderBeginCallCount = await tagReaderOrNil?.beginCallCount
        XCTAssertEqual(tagReaderBeginCallCount, 1)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    /// `NFCReader.begin(readerAndDelegate:detectingAlertMessage:)` を呼んだとき、`TagType.Reader.Session.readingAvailable` が `false` ならば `NFCReaderError` が返ってくる
    func testNFCReaderBeginWhenTagTypeReaderReadingAvailableIsFalse() async throws {
        #if canImport(CoreNFC)
        let tagReader = NFCTestReaderReadingUnavailable()
        let delegate = NFCTestReaderSessionReadingUnavailable()
        
        let reader = NFCReader<TestTag<NFCTestReaderReadingUnavailable>>()
        do {
            try await reader.begin(
                readerAndDelegate: { (tagReader, delegate) },
                detectingAlertMessage: "Detecting Alert Message"
            )
            XCTFail("The `NFCReaderErrorUnsupportedFeature` is not thrown.")
        } catch {
            XCTAssertEqual((error as! NFCReaderError).code, .readerErrorUnsupportedFeature)
            let tagReaderOrNil = await reader.readerAndDelegate?.reader
            XCTAssertNil(tagReaderOrNil)
            let tagReaderDelegateOrNil = await reader.readerAndDelegate?.delegate
            XCTAssertNil(tagReaderDelegateOrNil)
        }
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC)
private enum TestTag<Reader>: NFCTagType where Reader: Actor & NFCReaderProtocol & NFCReaderAfterBeginProtocol {
    typealias Reader = Reader
    typealias ReaderProtocol = Reader
    typealias ReaderDetectObject = Never
    
    enum DetectResult: NFCTagTypeFailableDetectResult {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
        
        static var success: Self { .success(alertMessage: nil) }
        static var restartPolling: Self { .restartPolling(alertMessage: nil) }
        static func failure(with error: any Error) -> Self {
            failure(errorMessage: error.localizedDescription)
        }
    }
}

private class NFCTestReaderSession: NSObject, NFCReaderSessionProtocol, @unchecked Sendable {
    let isReady: Bool = false
    var alertMessage: String = ""
    func invalidate() {}
    func invalidate(errorMessage: String) {}
    var beginCallCount = 0
    func begin() {
        beginCallCount += 1
    }
}

private actor NFCTestReaderReadingAvailable: NFCReaderProtocol, NFCReaderAfterBeginProtocol {
    typealias Session = NFCTestReaderSessionReadingAvailable
    typealias Delegate = NFCTestReaderSessionReadingAvailable
    typealias AfterBeginProtocol = NFCTestReaderReadingAvailable
    
    var taskPriority: TaskPriority?
    var delegate: AnyObject?
    static var readingAvailable: Bool { Session.readingAvailable }
    var sessionQueue: DispatchQueue { fatalError("dummy") }
    let isReady: Bool = false
    var alertMessage: String = ""
    func set(alertMessage: String) {
        self.alertMessage = alertMessage
    }
    var beginCallCount = 0
    func begin() {
        beginCallCount += 1
    }
    func invalidate() {}
    func invalidate(errorMessage: String) {}
}

private final class NFCTestReaderSessionReadingAvailable: NFCTestReaderSession {
    typealias Session = NFCTestReaderSessionReadingAvailable
    typealias AfterBeginProtocol = NFCTestReaderSessionReadingAvailable
    class var readingAvailable: Bool { true }
}

private actor NFCTestReaderReadingUnavailable: NFCReaderProtocol, NFCReaderAfterBeginProtocol {
    typealias Session = NFCTestReaderSessionReadingUnavailable
    typealias Delegate = NFCTestReaderSessionReadingUnavailable
    typealias AfterBeginProtocol = NFCTestReaderReadingUnavailable
    
    var taskPriority: TaskPriority?
    var delegate: AnyObject?
    static var readingAvailable: Bool { Session.readingAvailable }
    var sessionQueue: DispatchQueue { fatalError("dummy") }
    let isReady: Bool = false
    var alertMessage: String = ""
    func set(alertMessage: String) {
        self.alertMessage = alertMessage
    }
    var beginCallCount = 0
    func begin() {
        beginCallCount += 1
    }
    func invalidate() {}
    func invalidate(errorMessage: String) {}
}

private final class NFCTestReaderSessionReadingUnavailable: NFCTestReaderSession {
    typealias Session = NFCTestReaderSessionReadingUnavailable
    typealias AfterBeginProtocol = NFCTestReaderSessionReadingUnavailable
    class var readingAvailable: Bool { false }
}

private actor NFCTestReaderSessionDelegate: Actor {}
#endif
