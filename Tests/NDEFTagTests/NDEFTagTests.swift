//
//  NDEFTagTests.swift
//  NDEFTagTests
//
//  Created by treastrain on 2022/11/19.
//

import XCTest
#if canImport(CoreNFC)
@preconcurrency import protocol CoreNFC.NFCNDEFReaderSessionDelegate
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
            didBecomeActive: { reader in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NDEFTag.Reader>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetect: { reader, _ in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NDEFTag.Reader>.size)
                didDetectExpectation.fulfill()
                return .none
            }
        )
        let tagReaderOrNil = await reader.readerAndDelegate?.reader
        let tagReader = try XCTUnwrap(tagReaderOrNil)
        let tagReaderAlertMessage = await tagReader.alertMessage
        XCTAssertEqual(tagReaderAlertMessage, alertMessage)
        let tagReaderDelegate = await reader.readerAndDelegate?.delegate
        XCTAssertNotNil(tagReaderDelegate)
        
        let object = tagReaderDelegate as! NFCNDEFTagReaderCallbackHandleObject
        await object.didBecomeActive()
        await object.didDetect(tags: [])
        
        await fulfillment(of: [didBecomeActiveExpectation, didInvalidateExpectation, didDetectExpectation], timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NDEFTag.Reader.Session {
    open override class var readingAvailable: Bool { true }
}
#endif
