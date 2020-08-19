//
//  NFCTagReaderSession+Extension.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/25.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

private var _tagReaderSessionInvalidatedByUser = true

@available(iOS 13.0, *)
extension NFCTagReaderSession {
    
    public internal(set) var  isInvalidatedByUser: Bool {
        get {
            return _tagReaderSessionInvalidatedByUser
        }
        set {
            _tagReaderSessionInvalidatedByUser = newValue
        }
    }
    
    open func invalidateByReader(errorMessage: String? = nil) {
        self.isInvalidatedByUser = false
        
        if let errorMessage = errorMessage {
            super.invalidate(errorMessage: errorMessage)
        } else {
            super.invalidate()
        }
    }
}

#endif
