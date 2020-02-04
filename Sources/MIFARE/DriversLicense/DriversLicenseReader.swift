//
//  DriversLicenseReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import UIKit
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
public typealias DriversLicenseReaderViewController = UIViewController & DriversLicenseReaderSessionDelegate

@available(iOS 13.0, *)
internal typealias DriversLicenseCardTag = NFCISO7816Tag

@available(iOS 13.0, *)
public class DriversLicenseReader: JapanNFCReader {
    
    internal let delegate: DriversLicenseReaderSessionDelegate?
    private var driversLicenseCardItems: [DriversLicenseCardItem] = []
    
    private var pin1: [UInt8] = []
    private var pin2: [UInt8] = []
    
    private init() {
        fatalError()
    }
    
    /// DriversLicenseReader を初期化する。
    /// - Parameter delegate: DriversLicenseReaderSessionDelegate
    public init(delegate: DriversLicenseReaderSessionDelegate) {
        self.delegate = delegate
        super.init(delegate: delegate)
    }
    
    /// DriversLicenseReader を初期化する。
    /// - Parameter viewController: DriversLicenseReaderSessionDelegate を適用した UIViewController
    public init(viewController: DriversLicenseReaderViewController) {
        self.delegate = viewController
        super.init(viewController: viewController)
    }
    
    /// 運転免許証からデータを読み取る
    /// - Parameter items: 運転免許証から読み取りたいデータ
    /// - Parameter pin1: 暗証番号1
    /// - Parameter pin2: 暗証番号2
    public func get(items: [DriversLicenseCardItem], pin1: String = "", pin2: String = "") {
        if items.contains(.matters) || items.contains(.registeredDomicile) || items.contains(.photo) {
            if let pin = convertPINStringToJISX0201(pin1) {
                self.pin1 = pin
            } else {
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.incorrectPINFormat)
                return
            }
        }
        
        if items.contains(.registeredDomicile) || items.contains(.photo) {
            if let pin = convertPINStringToJISX0201(pin2) {
                self.pin2 = pin
            } else {
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.incorrectPINFormat)
                return
            }
        }
        
        self.driversLicenseCardItems = items
        self.beginScanning()
    }
    
    private func beginScanning() {
        guard self.checkReadingAvailable() else {
            print("""
                ------------------------------------------------------------
                【運転免許証を読み取るには】
                運転免許証を読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加します。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要があります。
                \t• Item 0: A0000002310100000000000000000000
                \t• Item 1: A0000002310200000000000000000000
                \t• Item 2: A0000002480300000000000000000000
                ------------------------------------------------------------
            """)
            return
        }
        
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = Localized.nfcReaderSessionAlertMessage.string()
        self.session?.begin()
    }
    
    public override func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        super.tagReaderSession(session, didInvalidateWithError: error)
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                print("""
                    ------------------------------------------------------------
                    【運転免許証を読み取るには】
                    運転免許証を読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加します。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要があります。
                    \t• Item 0: A0000002310100000000000000000000
                    \t• Item 1: A0000002310200000000000000000000
                    \t• Item 2: A0000002480300000000000000000000
                    ------------------------------------------------------------
                """)
            }
        }
        self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
    }
    
    public override func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(1000)
            let alertedMessage = session.alertMessage
            session.alertMessage = Localized.nfcTagReaderSessionDidDetectTagsMoreThan1TagIsDetectedMessage.string()
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
                session.alertMessage = alertedMessage
            })
            return
        }
        
        let tag = tags.first!
        
        session.connect(to: tag) { (error) in
            if nil != error {
                session.invalidate(errorMessage: Localized.nfcTagReaderSessionConnectErrorMessage.string())
                return
            }
            
            guard case NFCTag.iso7816(let driversLicenseCardTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = Localized.nfcTagReaderSessionDifferentTagTypeErrorMessage.string()
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            
            switch driversLicenseCardTag.initialSelectedAID {
            case "A0000002310100000000000000000000", "A0000002310200000000000000000000", "A0000002480300000000000000000000" :
                break
            default:
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = Localized.nfcTagReaderSessionDifferentTagTypeErrorMessage.string()
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            
            session.alertMessage = Localized.nfcTagReaderSessionReadingMessage.string()
            
            let driversLicenseCard = DriversLicenseCard(tag: driversLicenseCardTag)
            
            self.getItems(session, driversLicenseCard) { (driversLicenseCard) in
                session.alertMessage = Localized.nfcTagReaderSessionDoneMessage.string()
                session.invalidate()
                
                self.delegate?.driversLicenseReaderSession(didRead: driversLicenseCard)
            }
        }
    }
    
    private func getItems(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard, completion: @escaping (DriversLicenseCard) -> Void) {
        var driversLicenseCard = driversLicenseCard
        DispatchQueue(label: "TRETJPNRDriversLicenseReader", qos: .default).async {
            for item in self.driversLicenseCardItems {
                switch item {
                case .commonData:
                    driversLicenseCard = self.readCommonData(session, driversLicenseCard)
                case .pinSetting:
                    driversLicenseCard = self.readPINSetting(session, driversLicenseCard)
                case .matters:
                    driversLicenseCard = self.readMatters(session, driversLicenseCard, pin1: self.pin1)
                case .registeredDomicile:
                    driversLicenseCard = self.readRegisteredDomicile(session, driversLicenseCard, pin1: self.pin1, pin2: self.pin2)
                case .photo:
                    driversLicenseCard = self.readPhoto(session, driversLicenseCard, pin1: self.pin1, pin2: self.pin2)
                }
            }
            self.pin1 = []
            self.pin2 = []
            completion(driversLicenseCard)
        }
    }
}

#endif
