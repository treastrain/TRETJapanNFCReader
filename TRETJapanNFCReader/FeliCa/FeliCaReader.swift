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
open class FeliCaReader: JapanNFCReader, FeliCaReaderProtocol {
    
    internal let delegate: FeliCaReaderSessionDelegate?
    public var selectedSystemCodes: [FeliCaSystemCode]?
    
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
    
    public func beginScanning() {
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
            session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDidDetectTagsMoreThan1TagIsDetectedMessage")
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
                session.alertMessage = self.localizedString(key: "nfcReaderSessionAlertMessage")
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
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDifferentTagTypeErrorMessage")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = self.localizedString(key: "nfcReaderSessionAlertMessage")
                })
                return
            }
            
            session.alertMessage = self.localizedString(key: "nfcTagReaderSessionReadingMessage")
            
            let idm = feliCaCardTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
            guard let systemCode = FeliCaSystemCode(from: feliCaCardTag.currentSystemCode) else {
                // systemCode がこのライブラリでは対応していない場合
                session.invalidate(errorMessage: self.localizedString(key: "cardNotSupported"))
                return
            }
            
            if let selectedSystemCodes = self.selectedSystemCodes, !selectedSystemCodes.contains(systemCode) {
                let retryInterval = DispatchTimeInterval.milliseconds(1000)
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDifferentTagTypeErrorMessage")
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                    session.alertMessage = self.localizedString(key: "nfcReaderSessionAlertMessage")
                })
                return
            }
            
            var feliCaCard: FeliCaCard!
            switch systemCode {
            case .japanRailwayCybernetics:
                feliCaCard = TransitICCard(tag: feliCaCardTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
            case .iruca:
                feliCaCard = TransitICCard(tag: feliCaCardTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
            case .paspy:
                feliCaCard = TransitICCard(tag: feliCaCardTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
            case .sapica:
                feliCaCard = TransitICCard(tag: feliCaCardTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
            case .common:
                feliCaCard = FeliCaCommonCard(tag: feliCaCardTag, data: FeliCaCommonCardData(idm: idm, systemCode: systemCode))
            case .octopus:
                feliCaCard = OctopusCard(tag: feliCaCardTag, data: OctopusCardData(idm: idm, systemCode: systemCode))
            }
            
            self.getItems(session, feliCaCard) { (feliCaCard) in
                session.alertMessage = self.localizedString(key: "nfcTagReaderSessionDoneMessage")
                session.invalidate()
                
                self.delegate?.feliCaReaderSession(didRead: feliCaCard)
            }
        }
    }
    
    open func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        print("FeliCaReader.getItems を override することで読み取る item を指定できます")
        completion(feliCaCard)
    }
    
    internal func readWithoutEncryption(session: NFCTagReaderSession, tag: NFCFeliCaTag, serviceCode: FeliCaServiceCode, blocks: Int) -> [Data]? {
        var data: [Data]? = nil
        
        let semaphore = DispatchSemaphore(value: 0)
        let serviceCode = Data(serviceCode.uint8.reversed())
        
        tag.requestService(nodeCodeList: [serviceCode]) { (nodesData, error) in
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }
            
            guard let nodeData = nodesData.first, nodeData != Data([0xFF, 0xFF]) else {
                print("選択された node のサービスが存在しません")
                session.invalidate(errorMessage: "選択された node のサービスが存在しません")
                return
            }
            
            let blockList = (0..<blocks).map { (block) -> Data in
                Data([0x80, UInt8(block)])
            }
            
            tag.readWithoutEncryption24(serviceCode: serviceCode, blockList: blockList) { (status1, status2, blockData, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: error.localizedDescription)
                    return
                }
                
                guard status1 == 0x00, status2 == 0x00 else {
                    print("ステータスフラグがエラーを示しています", status1, status2)
                    session.invalidate(errorMessage: "ステータスフラグがエラーを示しています")
                    return
                }
                
                data = blockData
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        return data
    }
}
