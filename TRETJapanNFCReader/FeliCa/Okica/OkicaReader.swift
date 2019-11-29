//
//  OkicaReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias OkicaCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class OkicaReader: FeliCaReader {
    
    private var okicaCardItemTypes: [OkicaCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// OkicaReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// OkicaReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// OkicaReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// OKICA からデータを読み取る
    /// - Parameter itemTypes: OKICA から読み取りたいデータのタイプ
    public func get(itemTypes: [OkicaCardItemType]) {
        self.okicaCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [OkicaCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.okicaCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        var okicaCard = OkicaCard(tag: feliCaTag, data: OkicaCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNROkicaReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.okicaCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: okicaCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            okicaCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(okicaCard)
        }
    }
    
}
