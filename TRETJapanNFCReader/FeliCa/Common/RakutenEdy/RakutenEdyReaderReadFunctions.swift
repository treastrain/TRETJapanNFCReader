//
//  RakutenEdyReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
extension RakutenEdyReader {
    
    public func readBalance(_ session: NFCTagReaderSession, _ rakutenEdyCard: RakutenEdyCard) -> RakutenEdyCard {
        
        return rakutenEdyCard
    }
}
