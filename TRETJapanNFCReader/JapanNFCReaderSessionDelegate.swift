//
//  JapanNFCReaderSessionDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/09.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public protocol JapanNFCReaderSessionDelegate {
    func japanNFCReaderSession(didInvalidateWithError error: Error)
}
