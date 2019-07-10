//
//  ViewController.swift
//  TransitICReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class ViewController: UIViewController, TransitICReaderSessionDelegate {
    
    var reader: TransitICReader!
    var transitICCard: TransitICCard?
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var idmLabel: UILabel!
    @IBOutlet weak var systemCodeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = TransitICReader(viewController: self)
        self.reread()
    }
    
    @IBAction func reread() {
        self.reader.get(items: [.balance])
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                    self.balanceLabel.text = "¥ ----"
                    self.idmLabel.text = "IDm: "
                    self.systemCodeLabel.text = "System Code: "
                }
                
                self.transitICCard = nil
            }
        }
    }
    
    func transitICReaderSession(didRead transitICCard: TransitICCard) {
        self.transitICCard = transitICCard
        
        DispatchQueue.main.async {
            self.idmLabel.text = "IDm: \(transitICCard.idm)"
            self.systemCodeLabel.text = "System Code: \(transitICCard.systemCode)"
        }
    }


}

