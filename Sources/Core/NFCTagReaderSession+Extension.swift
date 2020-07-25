//
//  NFCTagReaderSession+Extension.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/25.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

private var _tagReaderSessionSuccessfullyFinished = false

@available(iOS 13.0, *)
extension NFCTagReaderSession {
    
    public internal(set) var isSuccessfullyFinished: Bool {
        get {
            return _tagReaderSessionSuccessfullyFinished
        }
        set {
            _tagReaderSessionSuccessfullyFinished = newValue
        }
    }
    
    open func invalidateSuccessfully() {
        self.isSuccessfullyFinished = true
        super.invalidate()
    }
}

#endif
