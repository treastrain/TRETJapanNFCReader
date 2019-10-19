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
    
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [TransitICCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.transitICCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        var transitICCard = TransitICCard(tag: feliCaTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRTransitICReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            
            if transitICCard.data.systemCode != FeliCaSystemCode.sapica {
                self.transitICCardItemTypes = self.transitICCardItemTypes.filter { $0 != .sapicaPoints }
            }
            
            for itemType in self.transitICCardItemTypes {
                data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: transitICCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            transitICCard.data.data = data
            completion(transitICCard)
        }
    }
}
