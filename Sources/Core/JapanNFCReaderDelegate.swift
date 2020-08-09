//
//  JapanNFCReaderDelegate.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/09.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

/// A protocol that an object implements to receive callbacks sent from an NFC reader.
@available(iOS 13.0, *)
public protocol JapanNFCReaderDelegate: class {
    func readerSessionDidBecomeActive()
    func readerSessionDidInvalidate(with result: Result<(NFCTagReaderSession, NFCTag), Error>)
}

#endif
