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
    func testNDEFTagNFCReaderReadDetectingAlertMessageDidBecomeActiveDidInvalidateDidDetect() async throws {
        #if canImport(CoreNFC) && !targetEnvironment(macCatalyst)
        let alertMessage = "Detecting Alert Message"
        
        let reader = NFCReader<NDEFTag>()
        try await reader.read(
            detectingAlertMessage: alertMessage,
            didBecomeActive: { _ in },
            didInvalidate: { _ in },
            didDetect: { session, tags in .none }
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
extension NDEFTag.ReaderSession {
    open override class var readingAvailable: Bool { true }
}
#endif