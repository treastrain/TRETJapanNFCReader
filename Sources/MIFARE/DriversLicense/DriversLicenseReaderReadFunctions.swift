//
//  DriversLicenseReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/01.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC

@available(iOS 13.0, *)
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
                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 17) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    let responseData = [UInt8](responseData)
                    
                    driversLicenseCard = driversLicenseCard.convert(items: .commonData, from: responseData)
                    
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
                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 3) { (responseData, sw1, sw2, error) in
                    // self.printData(responseData, isPrintData: true, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                        return
                    }
                    
                    let responseData = [UInt8](responseData)
                    
                    driversLicenseCard = driversLicenseCard.convert(items: .pinSetting, from: responseData)
                    
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    internal func readMatters(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard, pin1: [UInt8]) -> DriversLicenseCard {
        var driversLicenseCard = readPINSetting(session, driversLicenseCard)
        
        guard let pinSetting = driversLicenseCard.pinSetting else {
            print("暗証番号設定の情報を取得できず、記載事項(本籍除く)の取得をしませんでした")
            return driversLicenseCard
        }
        
        var pin1 = pin1
        if pinSetting.pinSetting {
            if pin1 == [0x2A, 0x2A, 0x2A, 0x2A] {
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.needPIN)
                session.invalidate(errorMessage: Localized.pinRequired.string())
                return driversLicenseCard
            }
        } else {
            self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.enteredPINWasIgnored)
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
                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.verify(tag: tag, pin: pin1) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                        return
                    }
                    
                    if sw1 != 0x90 {
                        let status = DriversLicenseReaderStatus(sw1: sw1, sw2: sw2)
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
                            
                            self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        }
                        session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                        return
                    }
                    
                    // データの読み取り
                    self.selectDF1(tag: tag) { (responseData, sw1, sw2, error) in
                        self.printData(responseData, sw1, sw2)
                        
                        if let error = error {
                            print(error.localizedDescription)
                            session.invalidate(errorMessage: "SELECT FILE DF1\n\(error.localizedDescription)")
                            return
                        }
                        
                        if sw1 != 0x90 {
                            session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                return
                            }
                            
                            self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 880) { (responseData, sw1, sw2, error) in
                                self.printData(responseData, sw1, sw2)
                                
                                if let error = error {
                                    print(error.localizedDescription)
                                    session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                                }
                                
                                if sw1 != 0x90 {
                                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                    return
                                }
                                
                                let responseData = [UInt8](responseData)
                                
                                driversLicenseCard = driversLicenseCard.convert(items: .matters, from: responseData)
                                
                                semaphore.signal()
                            }
                        }
                    }
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    internal func readRegisteredDomicile(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard, pin1: [UInt8], pin2: [UInt8]) -> DriversLicenseCard {
        var driversLicenseCard = readPINSetting(session, driversLicenseCard)
        
        guard let pinSetting = driversLicenseCard.pinSetting else {
            print("暗証番号設定の情報を取得できず、記載事項(本籍)の取得をしませんでした")
            return driversLicenseCard
        }
        
        var pin1 = pin1
        var pin2 = pin2
        if pinSetting.pinSetting {
            if pin1 == [0x2A, 0x2A, 0x2A, 0x2A] || pin2 == [0x2A, 0x2A, 0x2A, 0x2A] {
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.needPIN)
                session.invalidate(errorMessage: Localized.pinRequired.string())
                return driversLicenseCard
            }
        } else {
            self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.enteredPINWasIgnored)
            pin1 = [0x2A, 0x2A, 0x2A, 0x2A]
            pin2 = [0x2A, 0x2A, 0x2A, 0x2A]
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
                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.verify(tag: tag, pin: pin1) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                        return
                    }
                    
                    if sw1 != 0x90 {
                        let status = DriversLicenseReaderStatus(sw1: sw1, sw2: sw2)
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
                            
                            self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        }
                        session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                        return
                    }
                    
                    self.selectEF(tag: tag, data: [0x00, 0x02]) { (responseData, sw1, sw2, error) in
                        self.printData(responseData, sw1, sw2)
                        
                        if let error = error {
                            print(error.localizedDescription)
                            session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                            return
                        }
                        
                        if sw1 != 0x90 {
                            session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                            return
                        }
                        
                        self.verify(tag: tag, pin: pin2) { (responseData, sw1, sw2, error) in
                            self.printData(responseData, sw1, sw2)
                            
                            if let error = error {
                                print(error.localizedDescription)
                                session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                                return
                            }
                            
                            if sw1 != 0x90 {
                                let status = DriversLicenseReaderStatus(sw1: sw1, sw2: sw2)
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
                                    
                                    self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                                }
                                session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                                return
                            }
                            
                            // データの読み取り
                            self.selectDF1(tag: tag) { (responseData, sw1, sw2, error) in
                                self.printData(responseData, sw1, sw2)
                                
                                if let error = error {
                                    print(error.localizedDescription)
                                    session.invalidate(errorMessage: "SELECT FILE DF1\n\(error.localizedDescription)")
                                    return
                                }
                                
                                if sw1 != 0x90 {
                                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                    return
                                }
                                
                                self.selectEF(tag: tag, data: [0x00, 0x02]) { (responseData, sw1, sw2, error) in
                                    self.printData(responseData, sw1, sw2)
                                    
                                    if let error = error {
                                        print(error.localizedDescription)
                                        session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                                        return
                                    }
                                    
                                    if sw1 != 0x90 {
                                        session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                        return
                                    }
                                    
                                    self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 82) { (responseData, sw1, sw2, error) in
                                        self.printData(responseData, sw1, sw2)
                                        
                                        if let error = error {
                                            print(error.localizedDescription)
                                            session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                                        }
                                        
                                        if sw1 != 0x90 {
                                            session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                            return
                                        }
                                        
                                        let responseData = [UInt8](responseData)
                                        
                                        driversLicenseCard = driversLicenseCard.convert(items: .registeredDomicile, from: responseData)
                                        
                                        semaphore.signal()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    internal func readPhoto(_ session: NFCTagReaderSession, _ driversLicenseCard: DriversLicenseCard, pin1: [UInt8], pin2: [UInt8]) -> DriversLicenseCard {
        var driversLicenseCard = readPINSetting(session, driversLicenseCard)
        
        guard let pinSetting = driversLicenseCard.pinSetting else {
            print("暗証番号設定の情報を取得できず、記載事項(本籍)の取得をしませんでした")
            return driversLicenseCard
        }
        
        var pin1 = pin1
        var pin2 = pin2
        if pinSetting.pinSetting {
            if pin1 == [0x2A, 0x2A, 0x2A, 0x2A] || pin2 == [0x2A, 0x2A, 0x2A, 0x2A] {
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.needPIN)
                session.invalidate(errorMessage: Localized.pinRequired.string())
                return driversLicenseCard
            }
        } else {
            self.delegate?.japanNFCReaderSession(didInvalidateWithError: DriversLicenseReaderError.enteredPINWasIgnored)
            pin1 = [0x2A, 0x2A, 0x2A, 0x2A]
            pin2 = [0x2A, 0x2A, 0x2A, 0x2A]
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
                session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                    return
                }
                
                self.verify(tag: tag, pin: pin1) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                        return
                    }
                    
                    if sw1 != 0x90 {
                        let status = DriversLicenseReaderStatus(sw1: sw1, sw2: sw2)
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
                            
                            self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        }
                        session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                        return
                    }
                    
                    self.selectEF(tag: tag, data: [0x00, 0x02]) { (responseData, sw1, sw2, error) in
                        self.printData(responseData, sw1, sw2)
                        
                        if let error = error {
                            print(error.localizedDescription)
                            session.invalidate(errorMessage: "SELECT FILE EF\n\(error.localizedDescription)")
                            return
                        }
                        
                        if sw1 != 0x90 {
                            session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                            return
                        }
                        
                        self.verify(tag: tag, pin: pin2) { (responseData, sw1, sw2, error) in
                            self.printData(responseData, sw1, sw2)
                            
                            if let error = error {
                                print(error.localizedDescription)
                                session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                                return
                            }
                            
                            if sw1 != 0x90 {
                                let status = DriversLicenseReaderStatus(sw1: sw1, sw2: sw2)
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
                                    
                                    self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                                }
                                session.invalidate(errorMessage: "エラー: ステータス: \(status.description)")
                                return
                            }
                            
                            // データの読み取り
                            self.selectDF2(tag: tag) { (responseData, sw1, sw2, error) in
                                self.printData(responseData, sw1, sw2)
                                
                                if let error = error {
                                    print(error.localizedDescription)
                                    session.invalidate(errorMessage: "SELECT FILE DF2\n\(error.localizedDescription)")
                                    return
                                }
                                
                                if sw1 != 0x90 {
                                    session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
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
                                        session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                        return
                                    }
                                    
                                    self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 2005) { (responseData, sw1, sw2, error) in
                                        self.printData(responseData, sw1, sw2)
                                        
                                        if let error = error {
                                            print(error.localizedDescription)
                                            session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                                        }
                                        
                                        if sw1 != 0x90 {
                                            session.invalidate(errorMessage: "エラー: ステータス: \(DriversLicenseReaderStatus(sw1: sw1, sw2: sw2).description)")
                                            return
                                        }
                                        
                                        let responseData = [UInt8](responseData)
                                        
                                        driversLicenseCard = driversLicenseCard.convert(items: .photo, from: responseData)
                                        
                                        semaphore.signal()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        semaphore.wait()
        return driversLicenseCard
    }
    
    
}

#endif
