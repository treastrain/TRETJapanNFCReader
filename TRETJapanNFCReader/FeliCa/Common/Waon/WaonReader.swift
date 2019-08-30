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
    
    private var waonCardItems: [WaonCardItem] = []
    
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
    /// - Parameter items: WAONカードから読み取りたいデータ
    public func get(items: [WaonCardItem]) {
        self.waonCardItems = items
        self.beginScanning()
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        let feliCaCard = feliCaCard as! FeliCaCommonCard
        var waonCard = WaonCard(from: feliCaCard)
        DispatchQueue(label: "TRETJPNRWaonReader", qos: .default).async {
            for item in self.waonCardItems {
                switch item {
                case .balance:
                    waonCard = self.readBalance(session, waonCard)
                    break
                case .waonNumber:
                    waonCard = self.readWaonNumber(session, waonCard)
                case .points:
                    waonCard = self.readPoints(session, waonCard)
                case .transactions:
                    waonCard = self.readTransactions(session, waonCard)
                }
            }
            completion(waonCard)
        }
    }
}
