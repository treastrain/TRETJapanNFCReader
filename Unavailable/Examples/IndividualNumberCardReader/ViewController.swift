//
//  ViewController.swift
//  IndividualNumberCardReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import TRETJapanNFCReader

class ViewController: UIViewController, IndividualNumberReaderSessionDelegate {
    
    var reader: IndividualNumberReader!
    
    @IBOutlet weak var cardInfoInputSupportPINTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = IndividualNumberReader(delegate: self)
    }
    
    @IBAction func execute() {
        self.cardInfoInputSupportPINTextField.resignFirstResponder()
        
        let items: [IndividualNumberCardItem] = [.tokenInfo, .individualNumber]
        /// 券面事項入力補助用アプリの PIN
        let cardInfoInputSupportAppPIN = self.cardInfoInputSupportPINTextField.text ?? ""
        
        self.reader.get(items: items, cardInfoInputSupportAppPIN: cardInfoInputSupportAppPIN)
    }
    
    func individualNumberReaderSession(didRead individualNumberCardData: IndividualNumberCardData) {
        print(individualNumberCardData)
    }
    
    func lookupRemaining(pinType: IndividualNumberCardPINType, title: String) {
        self.reader.lookupRemainingPIN(pinType: pinType) { (remaining) in
            let remainingString = (remaining != nil) ? String(remaining!) : "error"
            self.showAlert(title: title, message: "Remaining: \(remainingString)")
        }
    }
    
    @IBAction func lookupRemainingForDigitalSignature() {
        self.lookupRemaining(pinType: .digitalSignature, title: "Digital Signature")
    }
    
    @IBAction func lookupRemainingForUserAuthentication() {
        self.lookupRemaining(pinType: .userAuthentication, title: "User Authentication")
    }
    
    @IBAction func lookupRemainingForCardInfoInputSupport() {
        self.lookupRemaining(pinType: .cardInfoInputSupport, title: "Card Info Input Support")
    }
    
    @IBAction func lookupRemainingForIndividualNumber() {
        self.lookupRemaining(pinType: .individualNumber, title: "Individual Number")
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        print(error)
    }
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

