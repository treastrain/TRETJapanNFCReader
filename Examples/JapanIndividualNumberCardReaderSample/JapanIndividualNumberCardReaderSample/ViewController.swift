//
//  ViewController.swift
//  JapanIndividualNumberCardReaderSample
//
//  Created by treastrain on 2021/10/17.
//

import UIKit
import JapanIndividualNumberCardReader

class ViewController: UITableViewController {
    
    var configuration: NFCKitReaderConfiguration!
    var reader: JapanIndividualNumberCardReader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Japan Individual Number Card Reader"
        
        configuration = NFCKitReaderConfiguration.default
        configuration.didBeginReaderAlertMessage = "Hold your iPhone to your Japan Individual Number Card."
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.scan)), animated: true)
    }
    
    @objc func scan() {
        self.reader = nil
        self.reader = JapanIndividualNumberCardReader(configuration: configuration, delegate: self)
        
        self.reader.read(items: JapanIndividualNumberCardItem.allCases) { _ in
            print(#line, #function)
        } didInvalidateWithError: { _, error in
            print(#line, #function, error)
        }
        
        // self.reader.read(items: JapanIndividualNumberCardItem.allCases)
    }
}

extension ViewController: JapanIndividualNumberCardReaderDelegate {
    func japanIndividualNumberCardReaderDidBecomeActive(_ reader: JapanIndividualNumberCardReader) {
        print(#line, #function)
    }
    
    func japanIndividualNumberCardReader(_ reader: JapanIndividualNumberCardReader, didInvalidateWithError error: Error) {
        print(#line, #function, error)
    }
}
