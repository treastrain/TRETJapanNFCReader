//
//  PINSettingViewController.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class PINSettingViewController: UITableViewController, DriversLicenseReaderSessionDelegate {

    var reader: DriversLicenseReader!
    var driversLicenseCard: DriversLicenseCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(viewController: self)
        self.reread()
    }
    
    @IBAction func reread() {
        self.reader.get(items: [.pinSetting])
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        var prompt: String? = nil
        
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                self.driversLicenseCard = nil
                prompt = error.localizedDescription
            }
        }
        
        DispatchQueue.main.async {
            self.navigationItem.prompt = prompt
            self.tableView.reloadData()
        }
    }
    
    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard) {
        self.driversLicenseCard = driversLicenseCard
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
        if let pinSetting = self.driversLicenseCard?.pinSetting?.pinSetting {
            let key = pinSetting ? "pinSettingTrue" : "pinSettingFalse"
            cell.detailTextLabel?.text = NSLocalizedString(key, bundle: Bundle(for: type(of: self)), comment: "")
        } else {
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }


}
