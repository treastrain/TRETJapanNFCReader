//
//  NativeTagTests.swift
//  NativeTagTests
//
//  Created by treastrain on 2022/10/23.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core
@testable import TRETNFCKit_NativeTag

final class NativeTagTests: XCTestCase {
    /// `NFCReader<NativeTag>.read(pollingOption:detectingAlertMessage:didBecomeActive:didInvalidate:didDetect:)` を呼んだとき、`pollingOption` の要素数が `0` なら `NFCReaderErrorInvalidParameter` のエラーが返ってくる
    func testNativeTagNFCReaderReadWhenPollingOptionIsEmpty() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        do {
            try await reader.read(pollingOption: [], detectingAlertMessage: alertMessage) { session, tags in .none }
            XCTFail("The `NFCReaderErrorInvalidParameter` is not thrown.")
        } catch {
            XCTAssertEqual((error as! NFCReaderError).code, .readerErrorInvalidParameter)
            let readerSession = await reader.sessionAndDelegate?.session
            XCTAssertNil(readerSession)
            let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
            XCTAssertNil(readerSessionDelegate)
        }
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    /// `NFCReader<NativeTag>.read(pollingOption:detectingAlertMessage:didBecomeActive:didInvalidate:didDetect:)` を呼んだとき、`pollingOption` の要素数が `1` なら処理に成功する
    func testNativeTagNFCReaderReadWithOnePollingOption() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        try await reader.read(pollingOption: .iso18092, detectingAlertMessage: alertMessage) { session, tags in .none }
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    /// `NFCReader<NativeTag>.read(pollingOption:detectingAlertMessage:didBecomeActive:didInvalidate:didDetect:)` を呼んだとき、`pollingOption` の要素数が `2` 以上なら処理に成功する
    func testNativeTagNFCReaderReadWithMultiplePollingOptions() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        try await reader.read(pollingOption: [.iso14443, .iso15693, .iso18092], detectingAlertMessage: alertMessage) { session, tags in .none }
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    func testNativeTagNFCReaderReadPollingOptionTaskPriorityDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let didBecomeActiveExpectation = expectation(description: "didBecomeActive")
        let didInvalidateExpectation = expectation(description: "didInvalidate")
        didInvalidateExpectation.expectedFulfillmentCount = 2
        let didDetectExpectation = expectation(description: "didDetect")
        
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        try await reader.read(
            pollingOption: [.iso14443, .iso15693, .iso18092],
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
