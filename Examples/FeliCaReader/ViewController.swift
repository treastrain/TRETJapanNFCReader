//
//  ViewController.swift
//  FeliCaReader
//
//  Created by treastrain on 2020/01/03.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import UIKit
import TRETJapanNFCReader

class ViewController: UIViewController, FeliCaReaderSessionDelegate {

    var reader: FeliCaReader!
    
    let transitICBalanceCommandParameter: FeliCaReadWithoutEncryptionCommandParameter = (systemCode: 0x0003, serviceCode: 0x008B, numberOfBlock: 1)
    let systemCode: FeliCaSystemCode = 0x0003
    let transitICTransactionsServiceCode: FeliCaServiceCode = 0x090F
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parameters: [FeliCaReadWithoutEncryptionCommandParameter] = [
            transitICBalanceCommandParameter,
            (systemCode, transitICTransactionsServiceCode, 20),
            (0x0003, 0x108F, 3)
        ]
        
        self.reader = FeliCaReader(delegate: self)
        self.reader.readWithoutEncryption(parameters: parameters)
    }
    
    func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        print(feliCaData)
        print(pollingErrors)
        print(readErrors)
        
        let balanceData = feliCaData[self.transitICBalanceCommandParameter]?.blockData
        let transactionsData = feliCaData[systemCode]?[transitICTransactionsServiceCode]?.blockData
        let entryExitInformationsData = feliCaData[0x0003]?[0x108F]?.blockData
        print("balanceData", balanceData)
        print("transactionsData", transactionsData)
        print("entryExitInformationsData", entryExitInformationsData)
    }
    
    func feliCaReaderSession(didRead feliCaCardData: FeliCaCardData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
    }
    
    func feliCaReaderSession(didInvalidateWithError pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        // print(error)
    }
}

