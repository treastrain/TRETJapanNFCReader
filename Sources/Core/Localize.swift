//
//  Localize.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/01.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, bundle: Bundle.module, comment: "")
}

public enum Localize {
    public enum String {
        public static let beginAlertMessage = LocalizedString("JapanNFCReader_begin_alertMessage")
        public static let tagReaderSessionMoreThanOneTagsFoundAlertMessage = LocalizedString("JapanNFCReader_tagReaderSession_moreThanOneTagsFoundAlertMessage")
        public static let done = LocalizedString("JapanNFCReader_done")
        
        public static let readingUnavailableErrorDescription = LocalizedString("JapanNFCReaderError_readingUnavailable_errorDescription")
        public static let couldNotCreateTagReaderSessionErrorDescription = LocalizedString("JapanNFCReaderError_couldNotCreateTagReaderSession_errorDescription")
        public static let invalidDetectedTagTypeErrorDescription = LocalizedString("JapanNFCReaderError_invalidDetectedTagType_errorDescription")
        public static let tagReaderSessionDidInvalidateWithErrorErrorDescription = LocalizedString("JapanNFCReaderError_tagReaderSessionDidInvalidateWithError_errorDescription")
        public static let tagReaderSessionConnectErrorErrorDescription = LocalizedString("JapanNFCReaderError_tagReaderSessionConnectError_errorDescription")
    }
}
