//
//  ISO7816TagReaderTests.swift
//  ISO7816Tests
//
//  Created by treastrain on 2022/11/22.
//

import XCTest
#if canImport(CoreNFC)
import CoreNFC
#endif

@testable import TRETNFCKit_Core
@testable import TRETNFCKit_ISO7816

final class ISO7816TagReaderTests: XCTestCase {
    func testISO7816TagReaderReadDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = ISO7816TagReader()
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
