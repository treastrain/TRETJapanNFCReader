//
//  ViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/06/12.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import TRETJapanNFCReader

class ViewController: UITableViewController {
    
    var reader: DriversLicenseReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "DriversLicenseReader - TRETJapanNFCReader"
    }
    
    
}


