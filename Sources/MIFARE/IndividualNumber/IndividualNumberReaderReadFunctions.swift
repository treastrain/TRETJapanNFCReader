//
//  IndividualNumberReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
extension IndividualNumberReader {
    
    internal func readJPKIToken(_ session: NFCTagReaderSession, _ individualNumberCard: IndividualNumberCard) -> IndividualNumberCard {
        let semaphore = DispatchSemaphore(value: 0)
        var individualNumberCard = individualNumberCard
        let tag = individualNumberCard.tag
        
        self.selectJPKIAP(tag: tag) { (responseData, sw1, sw2, error) in
            self.printData(responseData, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT JPKIAP\n\(error.localizedDescription)")
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(IndividualNumberReaderStatus(sw1: sw1, sw2: sw2).description)")
                return
            }
            
            self.selectEF(tag: tag, data: [0x00, 0x06]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 0x20) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    let responseString = String(data: responseData, encoding: .utf8) ?? ""
                    individualNumberCard.token = responseString.filter { $0 != " " }
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return individualNumberCard
    }
}

#endif
