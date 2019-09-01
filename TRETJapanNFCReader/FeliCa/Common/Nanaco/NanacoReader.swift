//
//  NanacoReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
public typealias NanacoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class NanacoReader: FeliCaReader {
    
    private var nanacoCardItemTypes: [NanacoCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// nanacoカードからデータを読み取る
    /// - Parameter itemTypes: nanacoカードから読み取りたいデータ
    public func get(itemTypes: [NanacoCardItemType]) {
        self.nanacoCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, itemTypes: [NanacoCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.nanacoCardItemTypes = itemTypes
        self.getItems(session, feliCaCard) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var nanacoCard = feliCaCard as! NanacoCard
        DispatchQueue(label: "TRETJPNRNanacoReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.nanacoCardItemTypes {
                data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: nanacoCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            nanacoCard.data.data = data
            completion(nanacoCard)
        }
    }
}
