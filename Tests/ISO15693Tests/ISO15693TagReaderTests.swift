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
    func testISO15693TagReaderReadDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = ISO15693TagReader()
        try await reader.read(
            detectingAlertMessage: alertMessage,
            didBecomeActive: { _ in },
            didInvalidate: { _ in },
            didDetect: { _, _ in .none }
        )
        let readerSessionOrNil = await reader.sessionAndDelegate?.session
        let readerSession = try XCTUnwrap(readerSessionOrNil)
        XCTAssertEqual(readerSession.alertMessage, alertMessage)
        let readerSessionDelegate = await reader.sessionAndDelegate?.delegate
        XCTAssertNotNil(readerSessionDelegate)
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
