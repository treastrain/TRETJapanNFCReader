//
//  PhotoViewController.swift
//  DriversLicenseReader
//
//  Created by treastrain on 2019/11/12.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import CoreNFC
import TRETJapanNFCReader

class PhotoViewController: UITableViewController, DriversLicenseReaderSessionDelegate {
    
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
        let alertController = UIAlertController(title: NSLocalizedString("enterPINsTitle", bundle: Bundle(for: type(of: self)), comment: ""), message: NSLocalizedString("enterPINsMessage", bundle: Bundle(for: type(of: self)), comment: ""), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("enterPIN1TextFieldPlaceholder", bundle: Bundle(for: type(of: self)), comment: "")
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("enterPIN2TextFieldPlaceholder", bundle: Bundle(for: type(of: self)), comment: "")
            textField.keyboardType = .numberPad
        }
        let nextAction = UIAlertAction(title: NSLocalizedString("next", bundle: Bundle(for: type(of: self)), comment: ""), style: .default) { (action) in
            guard let textFields = alertController.textFields, textFields.count == 2, let enteredPIN1 = textFields[0].text, let enteredPIN2 = textFields[1].text else {
                return
            }
            
            self.reader.get(items: [.photo], pin1: enteredPIN1, pin2: enteredPIN2)
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("photo", bundle: Bundle(for: type(of: self)), comment: "")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        if let photoData = self.driversLicenseCard?.photo?.photoData {
            imageView.image = UIImage(data: photoData)
            imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.copy(sender:))))
        } else {
            imageView.image = nil
        }

        return cell
    }
    
    @objc func copy(sender: UILongPressGestureRecognizer) {
        if let image = (sender.view as? UIImageView)?.image {
            let pasteboard = UIPasteboard.general
            pasteboard.image = image
            let alertController = UIAlertController(title: "Copied photo image.", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

}
