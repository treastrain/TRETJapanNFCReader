//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

public typealias TransitICReaderViewController = UIViewController & TransitICReaderSessionDelegate

internal typealias TransitICCardTag = NFCFeliCaTag

public class TransitICReader: JapanNFCReader {
    
    internal var delegate: TransitICReaderSessionDelegate?
    private var transitICCardItems: [TransitICCardItem] = []
    
    /// TransitICReader を初期化する。
    /// - Parameter viewController: TransitICReaderSessionDelegate を適用した UIViewController
    public init(_ viewController: TransitICReaderViewController) {
        super.init(viewController)
        self.delegate = viewController
    }
    
    /// 交通系ICカードからデータを読み取る
    /// - Parameter items: 交通系ICカードから読み取りたいデータ
    public func get(items: [TransitICCardItem]) {
        self.delegate = self.viewController as? TransitICReaderSessionDelegate
        
        self.transitICCardItems = items
        self.beginScanning()
    }
    
    private func beginScanning() {
        guard self.checkReadingAvailable() else {
            print("""
                ------------------------------------------------------------
                【交通系ICカードを読み取るには】
                交通系ICカード（Suica、PASMO など）を読み取るには、開発している iOS Application の Info.plist に "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" を追加します。ワイルドカードは使用できません。ISO18092 system codes for NFC Tag Reader Session には以下を含める必要があります。
                \t• Item 0: 0003
                ------------------------------------------------------------
            """)
            return
        }
        
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
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
                    【交通系ICカードを読み取るには】
                    交通系ICカード（Suica、PASMO など）を読み取るには、開発している iOS Application の Info.plist に "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" を追加します。ワイルドカードは使用できません。ISO18092 system codes for NFC Tag Reader Session には以下を含める必要があります。
                    \t• Item 0: 0003
                    ------------------------------------------------------------
                """)
            }
        }
        self.delegate?.transitICReaderSession(didInvalidateWithError: error)
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
            
            guard case NFCTag.feliCa(let transitICCardTag) = tag else {
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
            
            let idm = transitICCardTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
            let systemCode = transitICCardTag.currentSystemCode.map { String(format: "%.2hhx", $0) }.joined()
            let transitICCard = TransitICCard(tag: transitICCardTag, idm: idm, systemCode: systemCode)
            
            self.getItems(session, transitICCard) { (transitICCard) in
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDoneMessage")
                session.invalidate()
                
                self.delegate?.transitICReaderSession(didRead: transitICCard)
            }
        }
    }
    
    private func getItems(_ session: NFCTagReaderSession, _ transitICCard: TransitICCard, completion: @escaping (TransitICCard) ->  Void) {
        var transitICCard = transitICCard
        DispatchQueue(label: " TRETJPNRTransitICReader", qos: .default).async {
            for item in self.transitICCardItems {
                switch item {
                case .balance:
                    self.readBalance(session, transitICCard)
                    break
                }
                completion(transitICCard)
            }
        }
    }
}
