//
//  DriversLicenseReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/01.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

extension DriversLicenseReader {
    
    internal func readCommonData(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard) -> DriversLicenseCard {
        let semaphore = DispatchSemaphore(value: 0)
        var driversLicenseCard = driversLicenseCard
        let tag = driversLicenseCard.tag
        
        self.selectMF(tag: tag) { (responseData, sw1, sw2, error) in
            self.printData(responseData, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT FILE MF\n\(error.localizedDescription)")
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                return
            }
            
            self.selectEF(tag: tag, data: [0x2F, 0x01]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 17) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    let responseData = [UInt8](responseData)
                    
                    // let cardIssuerDataTag = responseData[0]
                    // let cardIssuerDataLength = responseData[1]
                    let specificationVersionNumberData = responseData[2...4]
                    let issuanceDateData = responseData[5...8]
                    let expirationDateData = responseData[9...12]
                    
                    // let preIssuanceDataTag = responseData[13]
                    // let preIssuanceDataLength = responseData[14]
                    let cardManufacturerIdentifierData = responseData[15]
                    let cryptographicFunctionIdentifierData = responseData[16]
                    
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyyMMdd"
                    
                    let specificationVersionNumber = String(data: Data(specificationVersionNumberData), encoding: .shiftJIS) ?? "nil"
                    let issuanceDateString = issuanceDateData.map { (data) -> String in
                        return data.toString()
                        }.joined()
                    let issuanceDate = formatter.date(from: issuanceDateString)!
                    let expirationDateString = expirationDateData.map { (data) -> String in
                        return data.toString()
                        }.joined()
                    let expirationDate = formatter.date(from: expirationDateString)!
                    
                    driversLicenseCard.commonData = DriversLicenseCard.CommonData(specificationVersionNumber: specificationVersionNumber, issuanceDate: issuanceDate, expirationDate: expirationDate, cardManufacturerIdentifier: cardManufacturerIdentifierData, cryptographicFunctionIdentifier: cryptographicFunctionIdentifierData)
                    
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    internal func readPINSetting(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard) -> DriversLicenseCard {
        let semaphore = DispatchSemaphore(value: 0)
        var driversLicenseCard = driversLicenseCard
        let tag = driversLicenseCard.tag
        
        self.selectMF(tag: tag) { (responseData, sw1, sw2, error) in
            self.printData(responseData, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT FILE MF\n\(error.localizedDescription)")
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                return
            }
            
            self.selectEF(tag: tag, data: [0x00, 0x0A]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 3) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    let responseData = [UInt8](responseData)
                    
                    let pinSettingDataTag = responseData[0]
                    let pinSettingDataLength = responseData[1]
                    let pinSettingData = responseData[2]
                    
                    var pinSetting: Bool {
                        if pinSettingData == 0x01 {
                            return true
                        } else if pinSettingData == 0x00 {
                            return false
                        }
                        return false
                    }
                    
                    driversLicenseCard.pinSetting = DriversLicenseCard.PINSetting(pinSetting: pinSetting)
                    
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    internal func readMatters(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard, pin1: [UInt8]) -> DriversLicenseCard {
        var driversLicenseCard = readPINSetting(session, driversLicenseCard)
        
        if let pinSetting = driversLicenseCard.pinSetting {
            var pin1 = pin1
            if !pinSetting.pinSetting {
                self.delegate?.driversLicenseReaderSession(didInvalidateWithError: DriversLicenseReaderError.enteredPINWasIgnored)
                pin1 = [0x2A, 0x2A, 0x2A, 0x2A]
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            let tag = driversLicenseCard.tag
            
            self.selectMF(tag: tag) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT FILE MF\n\(error.localizedDescription)")
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.selectEF(tag: tag, data: [0x00, 0x01]) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                        return
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(Status(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    //  PIN1の照合
                    self.verify(tag: tag, pin: pin1) { (responseData, sw1, sw2, error) in
                        self.printData(responseData, sw1, sw2)
                        
                        if let error = error {
                            print(error.localizedDescription)
                            session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                            return
                        }
                        
                        if sw1 != 0x90 {
                            let status = Status(sw1: sw1, sw2: sw2)
                            if sw1 == 0x63 {
                                var error = DriversLicenseReaderError.incorrectPIN(0)
                                switch status {
                                case .x63C1:
                                    error = .incorrectPIN(1)
                                case .x63C2:
                                    error = .incorrectPIN(2)
                                case .x63C3:
                                    error = .incorrectPIN(3)
                                default:
                                    break
                                }
                                
                                self.delegate?.driversLicenseReaderSession(didInvalidateWithError: error)
                            }
                            session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                            return
                        }
                        
                        // データの読み取り
                        
                        semaphore.signal()
                    }
                }
            }
            
            semaphore.wait()
            return driversLicenseCard
            
        } else {
            return driversLicenseCard
        }
    }
}
