//
//  NFCReader.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public actor NFCReader<TagType: NFCTagType> {
    #if canImport(CoreNFC)
    private var session: TagType.ReaderSession?
    private var sessionDelegate: AnyObject?
    #endif
    
    public init() {}
}

extension NFCReader {
    #if canImport(CoreNFC)
    public func read(
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
