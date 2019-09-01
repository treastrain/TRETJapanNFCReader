//
//  UnivCoopICPrepaidReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/24.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias UnivCoopICPrepaidCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class UnivCoopICPrepaidReader: FeliCaReader {
    
    private var univCoopICPrepaidCardItemTypes: [UnivCoopICPrepaidItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// UnivCoopICPrepaidReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// UnivCoopICPrepaidReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// UnivCoopICPrepaidReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    public func get(itemTypes: [UnivCoopICPrepaidItemType]) {
        self.univCoopICPrepaidCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, itemTypes: [UnivCoopICPrepaidItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.univCoopICPrepaidCardItemTypes = itemTypes
        self.getItems(session, feliCaCard) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var univCoopICPrepaidCard = feliCaCard as! UnivCoopICPrepaidCard
        DispatchQueue(label: "TRETJPNRUnivCoopICPrepaidReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.univCoopICPrepaidCardItemTypes {
               data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: univCoopICPrepaidCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            univCoopICPrepaidCard.data.data = data
            completion(univCoopICPrepaidCard)
        }
    }
}
