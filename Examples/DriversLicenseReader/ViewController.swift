//
//  ViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/06/12.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import TRETJapanNFCReader

class ViewController: UIViewController {
    
    var reader: DriversLicenseReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(self)
    }
    
    @IBAction func beginScanning() {
        reader.beginScanning()
    }
    
    
}


