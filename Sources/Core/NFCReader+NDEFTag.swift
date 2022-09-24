//
//  NFCReader+NDEFTag.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

extension NFCReader where TagType == NDEFTag {
    #if canImport(CoreNFC)
    public func read(
        detectingAlertMessage: String,
        didBecomeActive: @Sendable @escaping (_ session: TagType.ReaderSessionAlertMessageable) -> Void = { _ in },
        didInvalidate: @Sendable @escaping (NFCReaderError) -> Void = { _ in },
        didDetect: @Sendable @escaping (_ session: TagType.ReaderSessionProtocol, _ tags: TagType.ReaderSessionDetectObject) async throws -> TagType.DetectResult
    ) throws {
        let delegate = NFCNDEFTagReaderSessionCallbackHandleObject(
            didBecomeActive: didBecomeActive,
            didInvalidate: didInvalidate,
            didDetect: didDetect
        )
        try read(
            // TODO: support the `queue`
            sessionAndDelegate: { (.init(delegate: delegate, queue: nil, invalidateAfterFirstRead: false), delegate) },
            detectingAlertMessage: detectingAlertMessage
        )
    }
    #endif
}
