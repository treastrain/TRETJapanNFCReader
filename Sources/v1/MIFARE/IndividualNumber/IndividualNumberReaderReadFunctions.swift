//
//  IndividualNumberReaderReadFunctions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/10.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_MIFARE)
import TRETJapanNFCReader_MIFARE
#endif

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
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                return
            }
            
            self.selectEF(tag: tag, data: [0x00, 0x06]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT EF\n\(error.localizedDescription)")
                    self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                    return
                }
                
                self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 20) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                        self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        return
                    }
                    
                    if sw1 != 0x90 {
                        session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                        return
                    }
                    
                    let responseString = String(data: responseData, encoding: .utf8) ?? ""
                    individualNumberCard.data.token = responseString.filter { $0 != " " }
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return individualNumberCard
    }
    
    internal func readIndividualNumber(_ session: NFCTagReaderSession, _ individualNumberCard: IndividualNumberCard, cardInfoInputSupportAppPIN: [UInt8]) -> IndividualNumberCard {
        
        if cardInfoInputSupportAppPIN.isEmpty {
            session.invalidate(errorMessage: IndividualNumberReaderError.needPIN.errorDescription!)
            self.delegate?.japanNFCReaderSession(didInvalidateWithError: IndividualNumberReaderError.needPIN)
            return individualNumberCard
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        var individualNumberCard = individualNumberCard
        let tag = individualNumberCard.tag
        
        self.selectCardInfoInputSupportAP(tag: tag) { (responseData, sw1, sw2, error) in
            self.printData(responseData, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT TextAP\n\(error.localizedDescription)")
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                return
            }
            
            self.selectEF(tag: tag, data: [0x00, 0x11]) { (responseData, sw1, sw2, error) in
                self.printData(responseData, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT EF\n\(error.localizedDescription)")
                    self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                    return
                }
                
                self.verify(tag: tag, pin: cardInfoInputSupportAppPIN) { (responseData, sw1, sw2, error) in
                    self.printData(responseData, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                        self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        return
                    }
                    
                    if sw1 != 0x90 {
                        if sw1 == 0x63 {
                            var error = IndividualNumberReaderError.incorrectPIN(0)
                            switch sw2 {
                            case 0xC1:
                                error = .incorrectPIN(1)
                            case 0xC2:
                                error = .incorrectPIN(2)
                            case 0xC3:
                                error = .incorrectPIN(3)
                            case 0xC4:
                                error = .incorrectPIN(4)
                            case 0xC5:
                                error = .incorrectPIN(5)
                            default:
                                break
                            }
                            print("PIN エラー", error)
                            self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        }
                        session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                        return
                    }
                    
                    self.selectEF(tag: tag, data: [0x00, 0x01]) { (responseData, sw1, sw2, error) in
                        self.printData(responseData, sw1, sw2)
                        
                        if let error = error {
                            print(error.localizedDescription)
                            session.invalidate(errorMessage: "SELECT EF\n\(error.localizedDescription)")
                            self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                            return
                        }
                        
                        if sw1 != 0x90 {
                            session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                            return
                        }
                        
                        self.readBinary(tag: tag, p1Parameter: 0x00, p2Parameter: 0x00, expectedResponseLength: 17) { (responseData, sw1, sw2, error) in
                            self.printData(responseData, sw1, sw2)
                            
                            if let error = error {
                                print(error.localizedDescription)
                                session.invalidate(errorMessage: "READ BINARY\n\(error.localizedDescription)")
                                self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                                return
                            }
                            
                            if sw1 != 0x90 {
                                session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                                return
                            }
                            
                            var data = [UInt8](responseData)
                            data.removeFirst()
                            let fields = TLVField.sequenceOfFields(from: data)
                            
                            if let individualNumberData = fields.first?.value, let individualNumber = String(data: Data(individualNumberData), encoding: .utf8) {
                                individualNumberCard.data.individualNumber = individualNumber
                            }
                            
                            semaphore.signal()
                        }
                    }
                }
            }
        }
        
        semaphore.wait()
        return individualNumberCard
    }
    
    
    internal func lookupRemainingPIN(_ session: NFCTagReaderSession, _ tag: IndividualNumberCardTag, _ pinType: IndividualNumberCardPINType) -> Int? {
        var remaining: Int? = nil
        let semaphore = DispatchSemaphore(value: 0)
        
        let dfData: Data
        let efData: [UInt8]
        switch pinType {
        case .digitalSignature:
            dfData = IndividualNumberCardAID.jpkiAP
            efData = [0x00, 0x1B]
        case .userAuthentication:
            dfData = IndividualNumberCardAID.jpkiAP
            efData = [0x00, 0x18]
        case .cardInfoInputSupport:
            dfData = IndividualNumberCardAID.cardInfoInputSupportAP
            efData = [0x00, 0x11]
        case .individualNumber:
            dfData = IndividualNumberCardAID.individualNumberAP
            efData = [0x00, 0x1C]
        }
        
        self.selectDF(tag: tag, data: dfData) { (responseData, sw1, sw2, error) in
            // self.printData(responseData, isPrintData: true, sw1, sw2)
            
            if let error = error {
                print(error.localizedDescription)
                session.invalidate(errorMessage: "SELECT DF\n\(error.localizedDescription)")
                self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                semaphore.signal()
                return
            }
            
            if sw1 != 0x90 {
                session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                semaphore.signal()
                return
            }
            
            self.selectEF(tag: tag, data: efData) { (responseData, sw1, sw2, error) in
                // self.printData(responseData, isPrintData: true, sw1, sw2)
                
                if let error = error {
                    print(error.localizedDescription)
                    session.invalidate(errorMessage: "SELECT EF\n\(error.localizedDescription)")
                    self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                    semaphore.signal()
                    return
                }
                
                if sw1 != 0x90 {
                    session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                    semaphore.signal()
                    return
                }
                
                self.verify(tag: tag, pin: []) { (responseData, sw1, sw2, error) in
                    // self.printData(responseData, isPrintData: true, sw1, sw2)
                    
                    if let error = error {
                        print(error.localizedDescription)
                        session.invalidate(errorMessage: "VERIFY\n\(error.localizedDescription)")
                        self.delegate?.japanNFCReaderSession(didInvalidateWithError: error)
                        semaphore.signal()
                        return
                    }
                    
                    if sw1 == 0x63 {
                        remaining = Int(sw2 & 0x0F)
                    } else {
                        session.invalidate(errorMessage: "エラー: ステータス: \(ISO7816Status.localizedString(forStatusCode: sw1, sw2))")
                    }
                    
                    semaphore.signal()
                }
            }
        }
        
        semaphore.wait()
        return remaining
    }
}

#endif
