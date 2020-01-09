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

class ViewController: UIViewController, FeliCaReaderSessionDelegate {
    
    var reader: TransitICReader!
    var transitICCard: TransitICCard?
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var idmLabel: UILabel!
    @IBOutlet weak var systemCodeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = TransitICReader(delegate: self)
        self.reread()
    }
    
    @IBAction func reread() {
        self.reader.get(itemTypes: [.balance])
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
                    self.balanceLabel.text = "¥ -----"
                    self.idmLabel.text = "IDm: "
                    self.systemCodeLabel.text = "System Code: "
                }
                
                self.transitICCard = nil
            }
        }
    }
    
    func feliCaReaderSession(didRead feliCaCard: FeliCaCard) {
        let transitICCard = feliCaCard as! TransitICCard
        
        DispatchQueue.main.async {
            if let balance = transitICCard.data.balance {
                self.balanceLabel.text = "¥ \(balance)"
            } else {
                self.balanceLabel.text = "¥ -----"
            }
            self.idmLabel.text = "IDm: \(transitICCard.data.primaryIDm)"
            self.systemCodeLabel.text = "System Code: \(transitICCard.data.primarySystemCode.string)"
        }
        
        self.transitICCard = transitICCard
    }


}

