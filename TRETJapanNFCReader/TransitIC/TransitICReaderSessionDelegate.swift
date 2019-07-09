//
//  TransitICReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public protocol TransitICReaderSessionDelegate: JapanNFCReaderSessionDelegate {
    func transitICReaderSession(didRead transitICCard: TransitICCard)
}
