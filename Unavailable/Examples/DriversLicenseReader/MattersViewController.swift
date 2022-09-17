//
//  MattersViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/07/02.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class MattersViewController: UITableViewController, DriversLicenseReaderSessionDelegate {

    var reader: DriversLicenseReader!
    var driversLicenseCard: DriversLicenseCard?
    
    var isCalledViewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = DriversLicenseReader(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isCalledViewDidAppear {
            self.isCalledViewDidAppear = true
            self.reread()
        }
    }
    
    @IBAction func reread() {
        let alertController = UIAlertController(title: NSLocalizedString("enterPIN1Title", bundle: Bundle(for: type(of: self)), comment: ""), message: NSLocalizedString("enterPIN1Message", bundle: Bundle(for: type(of: self)), comment: ""), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("enterPIN1TextFieldPlaceholder", bundle: Bundle(for: type(of: self)), comment: "")
            textField.keyboardType = .numberPad
        }
        let nextAction = UIAlertAction(title: NSLocalizedString("next", bundle: Bundle(for: type(of: self)), comment: ""), style: .default) { (action) in
            guard let textFields = alertController.textFields, !textFields.isEmpty, let textField = textFields.first, let enteredPIN1 = textField.text else {
                return
            }
            
            self.reader.get(items: [.matters], pin1: enteredPIN1)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", bundle: Bundle(for: type(of: self)), comment: ""), style: .cancel, handler: nil)
        alertController.addAction(nextAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        
        if let driversLicenseReaderError = error as? DriversLicenseReaderError {
            self.driversLicenseCard = nil
            switch driversLicenseReaderError {
            case .incorrectPIN:
                let alertController = UIAlertController(
                    title: NSLocalizedString("incorrectPIN", bundle: Bundle(for: type(of: self)), comment: ""),
                    message: driversLicenseReaderError.errorDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            default:
                break
            }
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
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 4 {
            return NSLocalizedString("dateOfLicense", bundle: Bundle(for: type(of: self)), comment: "")
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 8
        case 3:
            return 2
        case 4:
            return 17
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = NSLocalizedString("jisX0208EstablishmentYearNumber", bundle: Bundle(for: type(of: self)), comment: "")
            cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.jisX0208EstablishmentYearNumber
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("name", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.name
            case 1:
                cell.textLabel?.text = NSLocalizedString("nickname", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.nickname
            case 2:
                cell.textLabel?.text = NSLocalizedString("commonName", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.commonName
            case 3:
                cell.textLabel?.text = NSLocalizedString("uniformName", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.uniformName
            case 4:
                cell.textLabel?.text = NSLocalizedString("birthdate", bundle: Bundle(for: type(of: self)), comment: "")
                let birthdate = self.driversLicenseCard?.matters?.birthdate
                cell.detailTextLabel?.text = birthdate.toString()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("address", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.address
            case 1:
                cell.textLabel?.text = NSLocalizedString("referenceNumber", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.referenceNumber
            case 2:
                cell.textLabel?.text = NSLocalizedString("color", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.color
            case 3:
                cell.textLabel?.text = NSLocalizedString("expirationDate", bundle: Bundle(for: type(of: self)), comment: "")
                let expirationDate = self.driversLicenseCard?.matters?.expirationDate
                cell.detailTextLabel?.text = expirationDate.toString()
            case 4:
                cell.textLabel?.text = NSLocalizedString("condition1", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.condition1
            case 5:
                cell.textLabel?.text = NSLocalizedString("condition2", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.condition2
            case 6:
                cell.textLabel?.text = NSLocalizedString("condition3", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.condition3
            case 7:
                cell.textLabel?.text = NSLocalizedString("condition4", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.condition4
            default:
                break
            }
        case 3:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("issuingAuthority", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.issuingAuthority
            case 1:
                cell.textLabel?.text = NSLocalizedString("number", bundle: Bundle(for: type(of: self)), comment: "")
                cell.detailTextLabel?.text = self.driversLicenseCard?.matters?.number
            default:
                break
            }
        case 4:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = NSLocalizedString("motorcycle", bundle: Bundle(for: type(of: self)), comment: "")
                let motorcycleLicenceDate = self.driversLicenseCard?.matters?.motorcycleLicenceDate
                cell.detailTextLabel?.text = motorcycleLicenceDate.toString()
            case 1:
                cell.textLabel?.text = NSLocalizedString("other", bundle: Bundle(for: type(of: self)), comment: "")
                let otherLicenceDate = self.driversLicenseCard?.matters?.otherLicenceDate
                cell.detailTextLabel?.text = otherLicenceDate.toString()
            case 2:
                cell.textLabel?.text = NSLocalizedString("class2", bundle: Bundle(for: type(of: self)), comment: "")
                let class2LicenceDate = self.driversLicenseCard?.matters?.class2LicenceDate
                cell.detailTextLabel?.text = class2LicenceDate.toString()
            case 3:
                cell.textLabel?.text = NSLocalizedString("heavyVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let heavyVehicleLicenceDate = self.driversLicenseCard?.matters?.heavyVehicleLicenceDate
                cell.detailTextLabel?.text = heavyVehicleLicenceDate.toString()
            case 4:
                cell.textLabel?.text = NSLocalizedString("ordinaryVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let ordinaryVehicleLicenceDate = self.driversLicenseCard?.matters?.ordinaryVehicleLicenceDate
                cell.detailTextLabel?.text = ordinaryVehicleLicenceDate.toString()
            case 5:
                cell.textLabel?.text = NSLocalizedString("heavySpecialVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let heavySpecialVehicleLicenceDate = self.driversLicenseCard?.matters?.heavySpecialVehicleLicenceDate
                cell.detailTextLabel?.text = heavySpecialVehicleLicenceDate.toString()
            case 6:
                cell.textLabel?.text = NSLocalizedString("heavyMotorcycle", bundle: Bundle(for: type(of: self)), comment: "")
                let heavyMotorcycleLicenceDate = self.driversLicenseCard?.matters?.heavyMotorcycleLicenceDate
                cell.detailTextLabel?.text = heavyMotorcycleLicenceDate.toString()
            case 7:
                cell.textLabel?.text = NSLocalizedString("ordinaryMotorcycle", bundle: Bundle(for: type(of: self)), comment: "")
                let ordinaryMotorcycleLicenceDate = self.driversLicenseCard?.matters?.ordinaryMotorcycleLicenceDate
                cell.detailTextLabel?.text = ordinaryMotorcycleLicenceDate.toString()
            case 8:
                cell.textLabel?.text = NSLocalizedString("smallSpecialVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let smallSpecialVehicleLicenceDate = self.driversLicenseCard?.matters?.smallSpecialVehicleLicenceDate
                cell.detailTextLabel?.text = smallSpecialVehicleLicenceDate.toString()
            case 9:
                cell.textLabel?.text = NSLocalizedString("trailer", bundle: Bundle(for: type(of: self)), comment: "")
                let trailerLicenceDate = self.driversLicenseCard?.matters?.trailerLicenceDate
                cell.detailTextLabel?.text = trailerLicenceDate.toString()
            case 10:
                cell.textLabel?.text = NSLocalizedString("class2HeavyVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let class2HeavyVehicleLicenceDate = self.driversLicenseCard?.matters?.class2HeavyVehicleLicenceDate
                cell.detailTextLabel?.text = class2HeavyVehicleLicenceDate.toString()
            case 11:
                cell.textLabel?.text = NSLocalizedString("class2OrdinaryVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let class2OrdinaryVehicleLicenceDate = self.driversLicenseCard?.matters?.class2OrdinaryVehicleLicenceDate
                cell.detailTextLabel?.text = class2OrdinaryVehicleLicenceDate.toString()
            case 12:
                cell.textLabel?.text = NSLocalizedString("class2HeavySpecialVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let class2HeavySpecialVehicleLicenceDate = self.driversLicenseCard?.matters?.class2HeavySpecialVehicleLicenceDate
                cell.detailTextLabel?.text = class2HeavySpecialVehicleLicenceDate.toString()
            case 13:
                cell.textLabel?.text = NSLocalizedString("class2Trailer", bundle: Bundle(for: type(of: self)), comment: "")
                let class2TrailerLicenceDate = self.driversLicenseCard?.matters?.class2TrailerLicenceDate
                cell.detailTextLabel?.text = class2TrailerLicenceDate.toString()
            case 14:
                cell.textLabel?.text = NSLocalizedString("mediumVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let mediumVehicleLicenceDate = self.driversLicenseCard?.matters?.mediumVehicleLicenceDate
                cell.detailTextLabel?.text = mediumVehicleLicenceDate.toString()
            case 15:
                cell.textLabel?.text = NSLocalizedString("class2MediumVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let class2MediumVehicleLicenceDate = self.driversLicenseCard?.matters?.class2MediumVehicleLicenceDate
                cell.detailTextLabel?.text = class2MediumVehicleLicenceDate.toString()
            case 16:
                cell.textLabel?.text = NSLocalizedString("semiMediumVehicle", bundle: Bundle(for: type(of: self)), comment: "")
                let semiMediumVehicleLicenceDate = self.driversLicenseCard?.matters?.semiMediumVehicleLicenceDate
                cell.detailTextLabel?.text = semiMediumVehicleLicenceDate.toString()
            default:
                break
            }
        default:
            break
        }

        return cell
    }

}
