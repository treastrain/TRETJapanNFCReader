//
//  DriversLicenseReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

public typealias DriversLicenseReaderViewController = UIViewController & DriversLicenseReaderSessionDelegate

internal typealias DriversLicenseCardTag = NFCISO7816Tag

public class DriversLicenseReader: JapanNFCReader {
    
    private var delegate: DriversLicenseReaderSessionDelegate?
    private var driversLicenseCardItems: [DriversLicenseCardItems] = []
    
    /// DriversLicenseReader を初期化する。
    /// - Parameter viewController: DriversLicenseReaderSessionDelegate を適用した UIViewController
    public init(_ viewController: DriversLicenseReaderViewController) {
        super.init(viewController)
        self.delegate = viewController
    }
    
    /// 運転免許証からデータを読み取る
    /// - Parameter items: 運転免許証から読み取りたいデータ
    public func get(items: [DriversLicenseCardItems]) {
        self.delegate = self.viewController as? DriversLicenseReaderSessionDelegate
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
        self.session?.alertMessage = self.localizedString(key: "nfcReaderSessionAlertMessage")
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
        self.delegate?.driversLicenseReaderSession(didInvalidateWithError: error)
    }
    
    public override func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(1000)
            let alertedMessage = session.alertMessage
            session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDidDetectTagsMoreThan1TagIsDetectedMessage")
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
                session.alertMessage = alertedMessage
            })
            return
        }
        
        let tag = tags.first!
        
        session.connect(to: tag) { (error) in
            if nil != error {
                session.invalidate(errorMessage: self.localizedString(key: "nfcTagReaderSessionConnectErrorMessage"))
                return
            }
            
            guard case NFCTag.iso7816(let driversLicenseCardTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                let alertedMessage = session.alertMessage
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDifferentTagTypeErrorMessage")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = alertedMessage
                })
                return
            }
            
            session.alertMessage = self.localizedString(key: "nfcTagReaderSessionReadingMessage")
            
            let driversLicenseCard = DriversLicenseCard(tag: driversLicenseCardTag)
            
            self.getItems(session, driversLicenseCard) { (driversLicenseCard) in
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDoneMessage")
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
                }
            }
            completion(driversLicenseCard)
        }
    }
    
    private func readCommonData(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard) -> DriversLicenseCard {
        let semaphore = DispatchSemaphore(value: 0)
        var driversLicenseCard = driversLicenseCard
        let tag = driversLicenseCard.tag
        
        self.selectMF(tag: tag) { (responseData, sw1, sw2, error) in
            self.printData(responseData, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT FILE MF\n\(error.localizedDescription)")
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                return
            }
            
            self.selectEF(tag: tag, data: [0x2F, 0x01]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 30) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    // デコード
                    let responseData = [UInt8](responseData)
                    
                    let cardIssuerDataTag = responseData[0]
                    let cardIssuerDataLength = responseData[1]
                    let specificationVersionNumberData = responseData[2...4]
                    let issuanceDateData = responseData[5...8]
                    let expirationDateData = responseData[9...12]
                    
                    let preIssuanceDataTag = responseData[13]
                    let preIssuanceDataLength = responseData[14]
                    let cardManufacturerIdentifierData = responseData[15]
                    let cryptographicFunctionIdentifierData = responseData[16]
                    
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyyMMdd"
                    
                    let specificationVersionNumber = String(data: Data(specificationVersionNumberData), encoding: .shiftJIS) ?? "nil"
                    let issuanceDateString = issuanceDateData.map { (data) -> String in
                        return data.toString()
                        }.joined()
                    let issuanceDate = formatter.date(from: issuanceDateString)!
                    let expirationDateString = expirationDateData.map { (data) -> String in
                        return data.toString()
                        }.joined()
                    let expirationDate = formatter.date(from: expirationDateString)!
                    
                    driversLicenseCard.commonData = DriversLicenseCard.CommonData(specificationVersionNumber: specificationVersionNumber, issuanceDate: issuanceDate, expirationDate: expirationDate, cardManufacturerIdentifier: cardManufacturerIdentifierData, cryptographicFunctionIdentifier: cryptographicFunctionIdentifierData)
                    
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
}
