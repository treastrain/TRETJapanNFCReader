//
//  WaonReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias WaonCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class WaonReader: FeliCaReader {
    
    private var waonCardItemTypes: [WaonCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// WaonReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// WaonReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// WaonReader を初期化する。
    /// - Parameter viewController: FeliCaReaderViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// WAONカードからデータを読み取る
    /// - Parameter itemTypes: WAONカードから読み取りたいデータ
    public func get(itemTypes: [WaonCardItemType]) {
        self.waonCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, itemTypes: [WaonCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.waonCardItemTypes = itemTypes
        self.getItems(session, feliCaCard) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var waonCard = feliCaCard as! WaonCard
        DispatchQueue(label: "TRETJPNRWaonReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.waonCardItemTypes {
                data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: waonCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            waonCard.data.data = data
            completion(waonCard)
        }
    }
}
