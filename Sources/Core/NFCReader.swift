//
//  NFCReader.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation
#if canImport(CoreNFC)
import CoreNFC
#endif

public actor NFCReader<TagType: NFCTagType> {
    #if canImport(CoreNFC)
    private(set) var session: TagType.ReaderSession?
    private(set) var sessionDelegate: AnyObject?
    #endif
    
    public init() {}
}

extension NFCReader {
    #if canImport(CoreNFC)
    func read(
        sessionAndDelegate: () throws -> (session: TagType.ReaderSession, delegate: TagType.ReaderSession.CallbackHandleObject),
        detectingAlertMessage: String
    ) throws {
        guard TagType.ReaderSession.readingAvailable else {
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        let sessionAndDelegate = try sessionAndDelegate()
        self.session = sessionAndDelegate.session
        self.sessionDelegate = sessionAndDelegate.delegate as AnyObject
        self.session?.alertMessage = detectingAlertMessage
        self.session?.begin()
    }
    #endif
}
