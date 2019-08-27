//
//  NanacoReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias NanacoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class NanacoReader: FeliCaReader {
    
    private var nanacoCardItems: [NanacoCardItem] = []
    
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
    /// - Parameter items: nanacoカードから読み取りたいデータ
    public func get(items: [NanacoCardItem]) {
        self.nanacoCardItems = items
        self.beginScanning()
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        let feliCaCard = feliCaCard as! FeliCaCommonCard
        var nanacoCard = NanacoCard(from: feliCaCard)
        DispatchQueue(label: " TRETJPNRNanacoReader", qos: .default).async {
            for item in self.nanacoCardItems {
                switch item {
                case .balance:
                    nanacoCard = self.readBalance(session, nanacoCard)
                    break
                }
            }
            completion(nanacoCard)
        }
    }
}
