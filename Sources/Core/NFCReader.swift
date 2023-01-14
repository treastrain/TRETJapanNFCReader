//
//  NFCReader.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

@_spi(AssertServices) import TRETNFCKit_AssertServices
import TRETNFCKit_InfoPListChecker

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
            #if DEBUG
            print("""
            -------------------------------------------------------------------------
            ⚠️ Developer Tips from TRETNFCKit (only visible in DEBUG builds) ⚠️
            Could not start NFC scan. Please check if your device supports "NFC with reader mode". If your device supports "NFC with reader mode" but you still receive this message, please check the following:
            \t• This message may appear when NFC is being used by another application or when you have just finished using NFC.
            \t• Select the iOS Application under development from the project's TARGET and enable "Near Field Communication Tag Reading" under "Signing & Capabilities" ("Near Field Communication Tag Reader Session Formats (com.apple.developer.nfc.readersession.formats)" must be included in the entitlements file).
            \t\t‣ Make sure "Near Field Communication Tag Reader Session Formats (com.apple.developer.nfc.readersession.formats)" contains valid values.
            \t• Add "Privacy - NFC Scan Usage Description (NFCReaderUsageDescription)" to the Info.plist of the iOS application you are developing. Failure to add this will result in a "Signal SIGABRT" error at runtime.
            If the above procedure does not improve the situation, also suspect a problem with the NFC module of the device.
            -------------------------------------------------------------------------
            """)
            #endif
            // FIXME: set the `userInfo`
            throw NFCReaderError(.readerErrorUnsupportedFeature)
        }
        
        #if DEBUG
        do {
            try InfoPListChecker.main.checkNFCReaderUsageDescription()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        #endif
        
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
