//
//  DriversLicenseViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/06/12.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import TRETJapanNFCReader

class DriversLicenseViewController: UITableViewController {
    
    var reader: DriversLicenseReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "DriversLicenseReader - TRETJapanNFCReader"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = NSLocalizedString("allFiles", bundle: Bundle(for: type(of: self)), comment: "")
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("commonDataElements", bundle: Bundle(for: type(of: self)), comment: "")
            case 1:
                cell.textLabel?.text = NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
            case 2:
                cell.textLabel?.text = NSLocalizedString("matters", bundle: Bundle(for: type(of: self)), comment: "")
            case 3:
                cell.textLabel?.text = NSLocalizedString("matters_registeredDomicile", bundle: Bundle(for: type(of: self)), comment: "")
            case 4:
                cell.textLabel?.text = NSLocalizedString("photo", bundle: Bundle(for: type(of: self)), comment: "")
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.performSegue(withIdentifier: "toAllFilesVC", sender: nil)
        case 1:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "toCommonDataElementsVC", sender: nil)
            case 1:
                self.performSegue(withIdentifier: "toPINSettingVC", sender: nil)
            case 2:
                self.performSegue(withIdentifier: "toMattersVC", sender: nil)
            case 3:
                self.performSegue(withIdentifier: "toRegisteredDomicileVC", sender: nil)
            case 4:
                self.performSegue(withIdentifier: "toPhotoVC", sender: nil)
            default:
                break
            }
        default:
            break
        }
    }
    
}

