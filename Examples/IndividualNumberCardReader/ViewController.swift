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
    }
    
    @IBAction func execute() {
        self.cardInfoInputSupportPINTextField.resignFirstResponder()
        
        let items: [IndividualNumberCardItem] = [.tokenInfo, .individualNumber]
        /// 券面事項入力補助用アプリの PIN
        let cardInfoInputSupportAppPIN = self.cardInfoInputSupportPINTextField.text ?? ""
        
        self.reader = IndividualNumberReader(delegate: self)
        self.reader.get(items: items, cardInfoInputSupportAppPIN: cardInfoInputSupportAppPIN)
    }
    
    func individualNumberReaderSession(didRead individualNumberCardData: IndividualNumberCardData) {
        print(individualNumberCardData)
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
}

