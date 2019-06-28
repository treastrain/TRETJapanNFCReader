//
//  DriversLicenseReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import UIKit
import CoreNFC

public class DriversLicenseReader: JapanNFCReader {
    
    public func beginScanning() {
        guard self.checkReadingAvailable() else {
            print("""
                ------------------------------------------------------------
                【運転免許証を読み取るには】
                運転免許証を読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加します。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要があります。
                \t• Item 0: A0000002310100000000000000000000
                \t• Item 1: A0000002310200000000000000000000
                \t• Item 2: A0000002480300000000000000000000
                ------------------------------------------------------------
            """)
            return
        }
        
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        self.session?.alertMessage = NSLocalizedString("nfcReaderSessionAlertMessage", bundle: Bundle(for: type(of: self)), comment: "")
        self.session?.begin()
    }
    
    public override func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        super.tagReaderSession(session, didInvalidateWithError: error)
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                print("""
                    ------------------------------------------------------------
                    【運転免許証を読み取るには】
                    運転免許証を読み取るには、開発している iOS Application の Info.plist に "ISO7816 application identifiers for NFC Tag Reader Session (com.apple.developer.nfc.readersession.iso7816.select-identifiers)" を追加します。ISO7816 application identifiers for NFC Tag Reader Session には以下を含める必要があります。
                    \t• Item 0: A0000002310100000000000000000000
                    \t• Item 1: A0000002310200000000000000000000
                    \t• Item 2: A0000002480300000000000000000000
                    ------------------------------------------------------------
                """)
            }
        }
    }
    
    
}
