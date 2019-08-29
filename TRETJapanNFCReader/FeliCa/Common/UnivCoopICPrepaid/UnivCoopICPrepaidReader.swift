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
    
    private var univCoopICPrepaidCardItems: [UnivCoopICPrepaidItem] = []
    
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
    
    public func get(items: [UnivCoopICPrepaidItem]) {
        self.univCoopICPrepaidCardItems = items
        self.beginScanning()
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        let feliCaCard = feliCaCard as! FeliCaCommonCard
        var univCoopICPrepaidCard = UnivCoopICPrepaidCard(from: feliCaCard)
        DispatchQueue(label: " TRETJPNRUnivCoopICPrepaidReader", qos: .default).async {
            for item in self.univCoopICPrepaidCardItems {
                switch item {
                case .balance:
                    univCoopICPrepaidCard = self.readBalance(session, univCoopICPrepaidCard)
                    break
                case .univCoopInfo:
                    univCoopICPrepaidCard = self.readUnivCoopInfo(session, univCoopICPrepaidCard)
                }
            }
            completion(univCoopICPrepaidCard)
        }
    }
}
