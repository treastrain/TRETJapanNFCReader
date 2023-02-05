//
//  ISO15693TagReaderTests.swift
//  ISO15693Tests
//
//  Created by treastrain on 2022/11/26.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core
@testable import TRETNFCKit_ISO15693

final class ISO15693TagReaderTests: XCTestCase {
    func testISO15693TagReaderReadTaskPriorityDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let didBecomeActiveExpectation = expectation(description: "didBecomeActive")
        let didInvalidateExpectation = expectation(description: "didInvalidate")
        didInvalidateExpectation.expectedFulfillmentCount = 2
        let didDetectExpectation = expectation(description: "didDetect")
        
        let alertMessage = "Detecting Alert Message"
        
        let reader = ISO15693TagReader()
        try await reader.read(
            taskPriority: nil,
            detectingAlertMessage: alertMessage,
            didBecomeActive: { session in
                XCTAssertEqual(MemoryLayout.size(ofValue: session), MemoryLayout<NativeTag.ReaderSession>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetect: { _, _ in
                didDetectExpectation.fulfill()
                return .none
            }
        )
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
        
        let object = readerSessionDelegate as! NFCNativeTagReaderSessionCallbackHandleObject
        object.tagReaderSessionDidBecomeActive(readerSession)
        object.tagReaderSession(readerSession, didDetect: [])
        
        await waitForExpectations(timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NativeTag.ReaderSession {
    open override class var readingAvailable: Bool { true }
}
#endif
