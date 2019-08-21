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
    
    internal init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    internal override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var rakutenEdyCard = feliCaCard as! RakutenEdyCard
        DispatchQueue(label: " TRETJPNRTransitICReader", qos: .default).async {
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
