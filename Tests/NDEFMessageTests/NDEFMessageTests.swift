//
//  NDEFMessageTests.swift
//  NDEFMessageTests
//
//  Created by treastrain on 2022/11/19.
//

import XCTest
#if canImport(CoreNFC)
@preconcurrency import protocol CoreNFC.NFCNDEFReaderSessionDelegate
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
            didBecomeActive: { reader in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NDEFMessage.Reader>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetectNDEFs: { reader, _ in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NDEFMessage.Reader>.size)
                didDetectNDEFsExpectation.fulfill()
                return .continue
            }
        )
        let tagReaderOrNil = await reader.readerAndDelegate?.reader
        let tagReader = try XCTUnwrap(tagReaderOrNil)
        let tagReaderAlertMessage = await tagReader.alertMessage
        XCTAssertEqual(tagReaderAlertMessage, alertMessage)
        let tagReaderDelegate = await reader.readerAndDelegate?.delegate
        XCTAssertNotNil(tagReaderDelegate)
        
        let object = tagReaderDelegate as! NFCNDEFMessageReaderCallbackHandleObject
        await object.didBecomeActive()
        await object.didDetectNDEFs(messages: [])
        
        await fulfillment(of: [didBecomeActiveExpectation, didInvalidateExpectation, didDetectNDEFsExpectation], timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NDEFMessage.Reader.Session {
    open override class var readingAvailable: Bool { true }
}
#endif
