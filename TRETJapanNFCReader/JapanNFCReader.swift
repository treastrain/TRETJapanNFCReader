//
//  JapanNFCReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/28.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC

public class JapanNFCReader {
    
    private let viewController: UIViewController
    
    public init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func beginScanning() {
        guard NFCReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: NSLocalizedString("nfcReadingUnavailableAlertTitle", bundle: Bundle(for: type(of: self)), comment: ""),
                message: NSLocalizedString("nfcReadingUnavailableAlertMessage", bundle: Bundle(for: type(of: self)), comment: ""),
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController.present(alertController, animated: true, completion: nil)
            return
        }
    }
}

