//
//  RakutenEdyReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias RakutenEdyCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class RakutenEdyReader: FeliCaReader {
    
    private var rakutenEdyCardItems: [RakutenEdyCardItem] = []
    
    private init() {
        fatalError()
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// 楽天Edyカードからデータを読み取る
    /// - Parameter items: 楽天Edyカードから読み取りたいデータ
    public func get(items: [RakutenEdyCardItem]) {
        self.rakutenEdyCardItems = items
        self.beginScanning()
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        let feliCaCard = feliCaCard as! FeliCaCommonCard
        var rakutenEdyCard = RakutenEdyCard(from: feliCaCard)
        DispatchQueue(label: " TRETJPNRRakutenEdyReader", qos: .default).async {
            for item in self.rakutenEdyCardItems {
                switch item {
                case .balance:
                    rakutenEdyCard = self.readBalance(session, rakutenEdyCard)
                    break
                }
            }
            completion(rakutenEdyCard)
        }
    }
}
