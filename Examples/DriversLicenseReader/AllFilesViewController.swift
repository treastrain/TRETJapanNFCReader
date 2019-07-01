//
//  AllFilesViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/07/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class AllFilesViewController: UITableViewController, DriversLicenseReaderSessionDelegate {

    var reader: DriversLicenseReader!
    var driversLicenseCard: DriversLicenseCard?
    
    var sectionTiles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(self)
        
        self.sectionTiles = [
            NSLocalizedString("cardIssuerData", bundle: Bundle(for: type(of: self)), comment: ""),
            NSLocalizedString("preIssuanceData", bundle: Bundle(for: type(of: self)), comment: ""),
            NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
        ]
        
        self.reread()
    }
    
    @IBAction func reread() {
        self.reader.get(items: DriversLicenseCardItems.allCases)
    }
    
    func driversLicenseReaderSession(didInvalidateWithError error: Error) {
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
        return self.sectionTiles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // カード発行者データ
            return 3
        case 1: // 発行前データ
            return 2
        case 2: // 暗証番号(PIN)設定
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: // カード発行者データ
            return NSLocalizedString("cardIssuerData", bundle: Bundle(for: type(of: self)), comment: "")
        case 1: // 発行前データ
            return NSLocalizedString("preIssuanceData", bundle: Bundle(for: type(of: self)), comment: "")
        case 2: // 暗証番号(PIN)設定
            return NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0: // カード発行者データ
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("specificationVersionNumber", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.commonData?.specificationVersionNumber
            case 1:
                cell.textLabel?.text = NSLocalizedString("issuanceDate", bundle: Bundle(for: type(of: self)), comment: "")
                let issuanceDate = self.driversLicenseCard?.commonData?.issuanceDate
                cell.detailTextLabel?.text = issuanceDate.toString()
            case 2:
                cell.textLabel?.text = NSLocalizedString("expirationDate", bundle: Bundle(for: type(of: self)), comment: "")
                let expirationDate = self.driversLicenseCard?.commonData?.expirationDate
                cell.detailTextLabel?.text = expirationDate.toString()
            default:
                break
            }
        case 1: // 発行前データ
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("cardManufacturerIdentifier", bundle: Bundle(for: type(of: self)), comment: "")
                let cardManufacturerIdentifier = self.driversLicenseCard?.commonData?.cardManufacturerIdentifier
                cell.detailTextLabel?.text = cardManufacturerIdentifier.toHexString()
            case 1:
                cell.textLabel?.text = NSLocalizedString("cryptographicFunctionIdentifier", bundle: Bundle(for: type(of: self)), comment: "")
                let cryptographicFunctionIdentifier = self.driversLicenseCard?.commonData?.cryptographicFunctionIdentifier
                cell.detailTextLabel?.text = cryptographicFunctionIdentifier.toHexString()
            default:
                break
            }
        case 2: // 暗証番号(PIN)設定
            cell.textLabel?.text = NSLocalizedString("pinSetting", bundle: Bundle(for: type(of: self)), comment: "")
            if let pinSetting = self.driversLicenseCard?.pinSetting?.pinSetting {
                let key = pinSetting ? "pinSettingTrue" : "pinSettingFalse"
                cell.detailTextLabel?.text = NSLocalizedString(key, bundle: Bundle(for: type(of: self)), comment: "")
            } else {
                cell.detailTextLabel?.text = nil
            }
        default:
            break
        }
        
        return cell
    }


}
