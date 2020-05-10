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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.execute()
    }
    
    @IBAction func execute() {
        self.reader = IndividualNumberReader(delegate: self)
        self.reader.get()
    }
    
    func individualNumberReaderSession(didRead individualNumberCard: IndividualNumberCard) {
        print(individualNumberCard)
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
}

