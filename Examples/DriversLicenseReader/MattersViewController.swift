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
        self.reader = DriversLicenseReader(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isCalledViewDidAppear {
            self.reread()
        }
    }
    
    @IBAction func reread() {
        let alertController = UIAlertController(title: NSLocalizedString("enterPIN1Title", bundle: Bundle(for: type(of: self)), comment: ""), message: NSLocalizedString("enterPIN1Message", bundle: Bundle(for: type(of: self)), comment: ""), preferredStyle: .alert)
        alertController.addTextField { (textField) in
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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
