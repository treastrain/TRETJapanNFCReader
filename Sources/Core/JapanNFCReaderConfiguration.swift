//
//  JapanNFCReaderConfiguration.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/25.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation

@available(iOS 13.0, *)
extension JapanNFCReader {
    
    public struct Configuration {
        public static let `default` = Configuration()
        private init() {}
        
        /**
         A Boolean value that indicates whether to return `NFCReaderError.readerSessionInvalidationErrorUserCanceled` after the NFC connection is completed.
         
         The `NFCReaderError.readerSessionInvalidationErrorUserCanceled` is the value of the `NFCTagReaderSessionDelegate.tagReaderSession(_:didInvalidateWithError:)` when the user taps its own cancel button and the NFC communication is terminated. However, the method tells the value even after the reader session has been successfully closed by `NFCReaderSessionProtocol.invalidate()`. If you set this Boolean value to false, it will not return it.
         
         The default value is false.
         */
        public var returnReaderSessionInvalidationErrorUserCanceledAfterNFCConnectionCompleted = false
        
        /**
         A Boolean value that indicates whether to continue processing even if an error occurs during processing.
         
         The default value is true.
         */
        public var continuesProcessIfErrorOccurred = true
    }
}

#endif
