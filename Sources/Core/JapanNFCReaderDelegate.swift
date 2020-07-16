//
//  JapanNFCReaderDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/09.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
public protocol JapanNFCReaderDelegate {
    func tagReaderSession(_ session: NFCTagReaderSession, didConnect tag: NFCTag)
}

#endif
