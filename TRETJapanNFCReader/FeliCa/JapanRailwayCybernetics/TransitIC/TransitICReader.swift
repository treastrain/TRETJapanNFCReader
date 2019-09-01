//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

//@available(iOS 13.0, *)
//public typealias TransitICReaderViewController = UIViewController & TransitICReaderSessionDelegate

@available(iOS 13.0, *)
public typealias TransitICCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class TransitICReader: FeliCaReader {
    
    private var transitICCardItemTypes: [TransitICCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// 交通系ICカードからデータを読み取る
    /// - Parameter items: 交通系ICカードから読み取りたいデータ
    public func get(itemTypes: [TransitICCardItemType]) {
        self.transitICCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, itemTypes: [TransitICCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.transitICCardItemTypes = itemTypes
        self.getItems(session, feliCaCard) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var transitICCard = feliCaCard as! TransitICCard
        DispatchQueue(label: "TRETJPNRTransitICReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.transitICCardItemTypes {
                data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: transitICCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            transitICCard.data.data = data
            completion(transitICCard)
        }
    }
}
