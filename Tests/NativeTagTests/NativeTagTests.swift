//
//  NativeTagTests.swift
//  NativeTagTests
//
//  Created by treastrain on 2022/10/23.
//

import XCTest
#if canImport(CoreNFC)
@preconcurrency import protocol CoreNFC.NFCTagReaderSessionDelegate
#endif

@testable import TRETNFCKit_Core
@testable public import TRETNFCKit_NativeTag

final class NativeTagTests: XCTestCase {
    /// `NFCReader<NativeTag>.read(pollingOption:detectingAlertMessage:didBecomeActive:didInvalidate:didDetect:)` を呼んだとき、`pollingOption` の要素数が `0` なら `NFCReaderErrorInvalidParameter` のエラーが返ってくる
    func testNativeTagNFCReaderReadWhenPollingOptionIsEmpty() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        do {
            try await reader.read(
                pollingOption: [],
                taskPriority: nil,
                detectingAlertMessage: alertMessage,
                didBecomeActive: { _ in },
                didInvalidate: { _ in },
                didDetect: { _, _ in .none }
            )
            XCTFail("The `NFCReaderErrorInvalidParameter` is not thrown.")
        } catch {
            XCTAssertEqual((error as! NFCReaderError).code, .readerErrorInvalidParameter)
            let tagReaderOrNil = await reader.readerAndDelegate?.reader
            XCTAssertNil(tagReaderOrNil)
            let tagReaderDelegate = await reader.readerAndDelegate?.delegate
            XCTAssertNil(tagReaderDelegate)
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
        try await reader.read(
            pollingOption: .iso18092,
            taskPriority: nil,
            detectingAlertMessage: alertMessage,
            didBecomeActive: { _ in },
            didInvalidate: { _ in },
            didDetect: { _, _ in .none }
        )
        let tagReaderOrNil = await reader.readerAndDelegate?.reader
        let tagReader = try XCTUnwrap(tagReaderOrNil)
        let tagReaderAlertMessage = await tagReader.alertMessage
        XCTAssertEqual(tagReaderAlertMessage, alertMessage)
        let tagReaderDelegate = await reader.readerAndDelegate?.delegate
        XCTAssertNotNil(tagReaderDelegate)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    /// `NFCReader<NativeTag>.read(pollingOption:detectingAlertMessage:didBecomeActive:didInvalidate:didDetect:)` を呼んだとき、`pollingOption` の要素数が `2` 以上なら処理に成功する
    func testNativeTagNFCReaderReadWithMultiplePollingOptions() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NativeTag>()
        try await reader.read(
            pollingOption: [.iso14443, .iso15693, .iso18092],
            taskPriority: nil,
            detectingAlertMessage: alertMessage,
            didBecomeActive: { _ in },
            didInvalidate: { _ in },
            didDetect: { _, _ in .none }
        )
        let tagReaderOrNil = await reader.readerAndDelegate?.reader
        let tagReader = try XCTUnwrap(tagReaderOrNil)
        let tagReaderAlertMessage = await tagReader.alertMessage
        XCTAssertEqual(tagReaderAlertMessage, alertMessage)
        let tagReaderDelegate = await reader.readerAndDelegate?.delegate
        XCTAssertNotNil(tagReaderDelegate)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
    
    func testNativeTagNFCReaderReadPollingOptionTaskPriorityDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(ObjectiveC) && canImport(CoreNFC) && !targetEnvironment(macCatalyst)
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
            didBecomeActive: { reader in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NativeTag.Reader>.size)
                didBecomeActiveExpectation.fulfill()
            },
            didInvalidate: { error in
                XCTAssertEqual(error.code, .readerErrorUnsupportedFeature)
                didInvalidateExpectation.fulfill()
            },
            didDetect: { reader, _ in
                XCTAssertEqual(MemoryLayout.size(ofValue: reader), MemoryLayout<NativeTag.Reader>.size)
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
        
        let object = tagReaderDelegate as! NFCNativeTagReaderCallBackHandleObject
        await object.didBecomeActive()
        await object.didDetect(tags: .init(tags: []))
        
        await fulfillment(of: [didBecomeActiveExpectation, didInvalidateExpectation, didDetectExpectation], timeout: 0.01)
        #else
        throw XCTSkip("Support for this platform is not considered.")
        #endif
    }
}

#if canImport(CoreNFC) && DEBUG
extension NativeTag.Reader.Session {
    open override class var readingAvailable: Bool { true }
}
#endif
