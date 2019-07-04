//
//  TransitICReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public protocol TransitICReaderSessionDelegate {
    func transitICReaderSession(didInvalidateWithError error: Error)
    func transitICReaderSession(didRead transitICCard: TransitICCard)
}
