//
//  NDEFTagTests.swift
//  NDEFTagTests
//
//  Created by treastrain on 2022/11/19.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core
@testable import TRETNFCKit_NDEFTag

final class NDEFTagTests: XCTestCase {
    func testNDEFTagNFCReaderReadTaskPriorityDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(ObjectiveC) && canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let didBecomeActiveExpectation = expectation(description: "didBecomeActive")
        let didInvalidateExpectation = expectation(description: "didInvalidate")
        didInvalidateExpectation.expectedFulfillmentCount = 2
        let didDetectExpectation = expectation(description: "didDetect")
        
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NDEFTag>()
        try await reader.read(
            taskPriority: nil,
            detectingAlertMessage: alertMessage,
            didBecomeActive: { session in
                XCTAssertEqual(MemoryLayout.size(ofValue: session), MemoryLayout<NDEFTag.ReaderSession>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetect: { session, _ in
                XCTAssertEqual(MemoryLayout.size(ofValue: session), MemoryLayout<NDEFTag.ReaderSession>.size)
                didDetectExpectation.fulfill()
                return .none
            }
        )
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
        
        let object = readerSessionDelegate as! NFCNDEFTagReaderSessionCallbackHandleObject
        object.readerSessionDidBecomeActive(readerSession)
        object.readerSession(readerSession, didDetect: [])
        
        await waitForExpectations(timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NDEFTag.ReaderSession {
    open override class var readingAvailable: Bool { true }
}
#endif
