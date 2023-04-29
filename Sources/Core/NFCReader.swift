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
    private(set) var readerAndDelegate: (reader: TagType.Reader, delegate: TagType.Reader.Delegate)? {
        didSet {
            NotificationCenter.default.post(name: .didChangeNFCReaderReaderAndDelegate, object: readerAndDelegateChangedObserver, userInfo: [.isNilReaderAndDelegate: readerAndDelegate == nil])
        }
    }
    private var readerAndDelegateChangedObserver: (any NSObjectProtocol)?
    #endif
    
    public init() {}
}
extension NFCReader {
    #if canImport(CoreNFC)
    public func begin(
        readerAndDelegate throwingReaderAndDelegate: @Sendable () throws -> (reader: TagType.Reader, delegate: TagType.Reader.Delegate),
        detectingAlertMessage: String
    ) async throws {
        guard TagType.Reader.readingAvailable else {
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
        
        await withCheckedContinuation { continuation in
            guard readerAndDelegate != nil else { return continuation.resume() }
            readerAndDelegateChangedObserver = NotificationCenter.default.addObserver(forName: .didChangeNFCReaderReaderAndDelegate, object: nil, queue: nil) { notification in
                if (notification.userInfo ?? [:])[.isNilReaderAndDelegate] as? Bool == true {
                    NotificationCenter.default.removeObserver(notification.object as Any)
                    continuation.resume()
                }
            }
        }
        try Task.checkCancellation()
        
        readerAndDelegate = try throwingReaderAndDelegate()
        await readerAndDelegate?.reader.set(alertMessage: detectingAlertMessage)
        await readerAndDelegate?.reader.begin()
    }
    
    public func invalidate() async {
        if await readerAndDelegate?.reader.isReady == false {
            await readerAndDelegate?.reader.invalidate()
        }
        readerAndDelegate = nil
    }
    #endif
}

extension Notification.Name {
    fileprivate static let didChangeNFCReaderReaderAndDelegate: Self = .init("jp.tret.nfckit.didChangeNFCReaderReaderAndDelegate")
}

extension AnyHashable {
    fileprivate static var isNilReaderAndDelegate: Self { #function }
}
