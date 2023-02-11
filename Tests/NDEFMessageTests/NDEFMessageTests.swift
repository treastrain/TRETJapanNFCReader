//
//  NDEFMessageTests.swift
//  NDEFMessageTests
//
//  Created by treastrain on 2022/11/19.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core
@testable import TRETNFCKit_NDEFMessage

final class NDEFMessageTests: XCTestCase {
    func testNDEFMessageNFCReaderReadTaskPriorityInvalidateAfterFirstReadDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetectNDEFs() async throws {
        #if canImport(ObjectiveC) && canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let didBecomeActiveExpectation = expectation(description: "didBecomeActive")
        let didInvalidateExpectation = expectation(description: "didInvalidate")
        didInvalidateExpectation.expectedFulfillmentCount = 2
        let didDetectNDEFsExpectation = expectation(description: "didDetectNDEFs")
        
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NDEFMessage>()
        try await reader.read(
            taskPriority: nil,
            invalidateAfterFirstRead: false,
            detectingAlertMessage: alertMessage,
            didBecomeActive: { session in
                XCTAssertEqual(MemoryLayout.size(ofValue: session), MemoryLayout<NDEFMessage.ReaderSession>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetectNDEFs: { session, _ in
                XCTAssertEqual(MemoryLayout.size(ofValue: session), MemoryLayout<NDEFMessage.ReaderSession>.size)
                didDetectNDEFsExpectation.fulfill()
                return .continue
            }
        )
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
        
        let object = readerSessionDelegate as! NFCNDEFMessageReaderSessionCallbackHandleObject
        object.readerSessionDidBecomeActive(readerSession)
        object.readerSession(readerSession, didDetectNDEFs: [])
        
        await waitForExpectations(timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NDEFMessage.ReaderSession {
    open override class var readingAvailable: Bool { true }
}
#endif
