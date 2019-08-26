//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias TransitICReaderViewController = UIViewController & TransitICReaderSessionDelegate

@available(iOS 13.0, *)
public typealias TransitICCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class TransitICReader: FeliCaReader {
    
    private var transitICCardItems: [TransitICCardItem] = []
    
    private init() {
        fatalError()
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter delegate: TransitICReaderSessionDelegate
    public init(delegate: TransitICReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter viewController: TransitICReaderSessionDelegate を適用した UIViewController
    public init(viewController: TransitICReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// 交通系ICカードからデータを読み取る
    /// - Parameter items: 交通系ICカードから読み取りたいデータ
    public func get(items: [TransitICCardItem]) {
        self.transitICCardItems = items
        self.beginScanning()
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var transitICCard = feliCaCard as! TransitICCard
        DispatchQueue(label: " TRETJPNRTransitICReader", qos: .default).async {
            for item in self.transitICCardItems {
                switch item {
                case .balance:
                    transitICCard = self.readBalance(session, transitICCard)
                    break
                case .transactions:
                    transitICCard = self.readTransactionsData(session, transitICCard)
                    break
                }
            }
            completion(transitICCard)
        }
    }
}
