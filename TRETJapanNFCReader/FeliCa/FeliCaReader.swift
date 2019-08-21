//
//  FeliCaReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias FeliCaReaderViewController = UIViewController & FeliCaReaderSessionDelegate

@available(iOS 13.0, *)
public class FeliCaReader: JapanNFCReader {
    
    internal let delegate: FeliCaReaderSessionDelegate?
    private var feliCaCardItems: [FeliCaSystemCode : [FeliCaCardItem]] = [:]
    
    private init() {
        fatalError()
    }
    
    /// FeliCaReader を初期化する
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public init(delegate: FeliCaReaderSessionDelegate) {
        self.delegate = delegate
        super.init(delegate: delegate)
    }
    
    /// FeliCaReader を初期化する
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public init(viewController: FeliCaReaderViewController) {
        self.delegate = viewController
        super.init(viewController: viewController)
    }
    
    /// FeliCa カードからデータを読み取る
    /// - Parameter cardItems: FeliCa カードのシステムコードと読み取りたいデータのペア
    public func get(cardItems: [FeliCaSystemCode : [FeliCaCardItem]]) {
        self.feliCaCardItems = cardItems
        self.beginScanning()
    }
    
    internal func beginScanning() {
        guard self.checkReadingAvailable() else {
            print("""
                ------------------------------------------------------------
                【FeliCa カードを読み取るには】
                FeliCa カードを読み取るには、開発している iOS Application の Info.plist に "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" を追加します。ワイルドカードは使用できません。ISO18092 system codes for NFC Tag Reader Session にシステムコードを追加します。
                ------------------------------------------------------------
            """)
            return
        }
        
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
        self.session?.alertMessage = self.localizedString(key: "nfcReaderSessionAlertMessage")
        self.session?.begin()
    }
    
    public override func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                print("""
                    ------------------------------------------------------------
                    【FeliCa カードを読み取るには】
                    FeliCa カードを読み取るには、開発している iOS Application の Info.plist に "ISO18092 system codes for NFC Tag Reader Session (com.apple.developer.nfc.readersession.felica.systemcodes)" を追加します。ワイルドカードは使用できません。ISO18092 system codes for NFC Tag Reader Session にシステムコードを追加します。
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
            
            guard case NFCTag.feliCa(let feliCaCardTag) = tag else {
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
            
            let idm = feliCaCardTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
            guard let systemCode = FeliCaSystemCode(from: feliCaCardTag.currentSystemCode) else {
                // systemCode がこのライブラリでは対応していない場合
                return
            }
            
            var feliCaCard: FeliCaCard!
            switch systemCode {
            case .japanRailwayCybernetics:
                feliCaCard = TransitICCard(tag: feliCaCardTag, idm: idm, systemCode: systemCode)
            case .common:
                break
            }
            
            self.getItems(session, feliCaCard) { (feliCaCard) in
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDoneMessage")
                session.invalidate()
                
                self.delegate?.feliCaReaderSession(didRead: feliCaCard)
            }
        }
    }
    
    internal func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        DispatchQueue(label: "TRETJPNRFeliCaReader", qos: .default).async {
            if let items = self.feliCaCardItems[feliCaCard.systemCode] {
                switch feliCaCard.systemCode {
                case .japanRailwayCybernetics:
                    let items = items as! [TransitICCardItem]
                    var transitICCard = feliCaCard as! TransitICCard
                    for item in items {
                        switch item {
                        case .balance:
                            transitICCard = TransitICReader(feliCaReader: self).readBalance(session, transitICCard)
                        }
                    }
                    completion(transitICCard)
                case .common:
                    break
                }
            } else {
                completion(feliCaCard)
            }
        }
    }
    
}
