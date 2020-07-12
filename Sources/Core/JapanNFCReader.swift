//
//  JapanNFCReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

/// The abstract base class that represents a NFC reader.
@available(iOS 13.0, *)
open class JapanNFCReader: NSObject, NFCTagReaderSessionDelegate {
    open func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        
    }
    
    open func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        
    }
}

#endif
