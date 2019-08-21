//
//  CommonReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

@available(iOS 13.0, *)
public typealias CommonCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class CommonReader: FeliCaReader {
    
    private init() {
        fatalError()
    }
    
    internal init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        
    }
}
