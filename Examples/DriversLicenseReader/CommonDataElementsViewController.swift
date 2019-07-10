//
//  CommonDataElementsViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class CommonDataElementsViewController: UITableViewController, DriversLicenseReaderSessionDelegate {
    
    var reader: DriversLicenseReader!
    var driversLicenseCard: DriversLicenseCard?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(viewController: self)
        self.reread()
    }
    
    @IBAction func reread() {
        self.reader.get(items: [.commonData])
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error)  {
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("cardIssuerData", bundle: Bundle(for: type(of: self)), comment: "")
        } else if section == 1 {
            return NSLocalizedString("preIssuanceData", bundle: Bundle(for: type(of: self)), comment: "")
        }
        
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
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
        case 1:
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
        default:
            break
        }

        return cell
    }


}
