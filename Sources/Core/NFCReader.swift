//
//  NFCReader.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public actor NFCReader<TagType: NFCTagType> {
    #if canImport(CoreNFC)
    private(set) var sessionAndDelegate: (session: TagType.ReaderSession, delegate: AnyObject)? {
        didSet {
            NotificationCenter.default.post(name: .didChangeNFCReaderSessionAndDelegate, object: sessionAndDelegateChangedObserver, userInfo: [.isNilSessionAndDelegate: sessionAndDelegate == nil])
        }
    }
    private var sessionAndDelegateChangedObserver: (any NSObjectProtocol)?
    #endif
    
    public init() {}
}

extension NFCReader {
    #if canImport(CoreNFC)
    public func begin(
        sessionAndDelegate throwingSessionAndDelegate: () throws -> (session: TagType.ReaderSession, delegate: TagType.ReaderSession.Delegate),
        detectingAlertMessage: String
    ) async throws {
        guard TagType.ReaderSession.readingAvailable else {
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        
        await withCheckedContinuation { [sessionAndDelegate] continuation in
            guard sessionAndDelegate != nil else { return continuation.resume() }
            sessionAndDelegateChangedObserver = NotificationCenter.default.addObserver(forName: .didChangeNFCReaderSessionAndDelegate, object: nil, queue: nil) { notification in
                if (notification.userInfo ?? [:])[.isNilSessionAndDelegate] as? Bool == true {
                    NotificationCenter.default.removeObserver(notification.object as Any)
                    continuation.resume()
                }
            }
        }
        
        let sessionAndDelegate = try throwingSessionAndDelegate()
        self.sessionAndDelegate = (sessionAndDelegate.session, sessionAndDelegate.delegate as AnyObject)
        self.sessionAndDelegate?.session.alertMessage = detectingAlertMessage
        self.sessionAndDelegate?.session.begin()
    }
    
    public func invalidate() {
        self.sessionAndDelegate = nil
    }
    #endif
}

extension Notification.Name {
    fileprivate static let didChangeNFCReaderSessionAndDelegate: Self = .init("DidChangeNFCReaderSessionAndDelegate")
}

extension AnyHashable {
    fileprivate static var isNilSessionAndDelegate: Self { #function }
}
