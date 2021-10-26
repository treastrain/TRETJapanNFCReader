//
//  JapanIndividualNumberCardReader+Extension.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/26.
//

import NFCKitReaderCore

@available(iOS 13.0, *)
extension JapanIndividualNumberCardReader {
    static func convertToJISX0201(item: JapanIndividualNumberCardItem, pinString: String) -> Result<[UInt8], NFCKitReaderError> {
        let pinCharacterCountCondition: (Int) -> Bool
        let predicate: (UInt8) -> Bool
        switch item {
        case .electronicCertificateForTheBearersSignature:
            pinCharacterCountCondition = { 6...16 ~= $0 }
            predicate = { 0x30...0x39 ~= $0 || 0x41...0x5A ~= $0 }
        case .electronicCertificateForUserIdentification:
            pinCharacterCountCondition = { $0 == 4 }
            predicate = { 0x30...0x39 ~= $0 }
        case .cardInfoInputSupportApplication:
            pinCharacterCountCondition = { $0 == 4 }
            predicate = { 0x30...0x39 ~= $0 }
        case .basicResidentRegistration:
            pinCharacterCountCondition = { $0 == 4 }
            predicate = { 0x30...0x39 ~= $0 }
        }
        
        guard let pinData = pinString.data(using: .utf8), pinCharacterCountCondition(pinData.count), pinData.allSatisfy(predicate) else {
            return .failure(.notStartedScanBecausePINFormatInvalid)
        }
        
        return .success([UInt8](pinData))
    }
}
