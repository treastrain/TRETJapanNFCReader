//
//  JapanIndividualNumberCardReader+CardInfoInputSupportApplication.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/21.
//

#if os(iOS)
import NFCKitReaderCore

@available(iOS 13.0, *)
internal extension JapanIndividualNumberCardReader {
    func readCardInfoInputSupportApplication(_ session: NFCTagReaderSession, didDetect tag: NFCISO7816Tag, pin: [UInt8]) {
        let aid = JapanIndividualNumberCardItem.cardInfoInputSupportApplication.aid
        tag.selectDF(data: aid) { payload, statusWord1, statusWord2, error in
            if let error = error {
                // エラー処理
                return
            }
            // statusWord の確認
            
            tag.selectEF(data: Data([0x00, 0x11])) { payload, statusWord1, statusWord2, error in
                if let error = error {
                    // エラー処理
                    return
                }
                // statusWord の確認
                
                tag.verify(p1Parameter: 0x00, p2Parameter: 0x80, data: Data(pin), expectedResponseLength: -1) { payload, statusWord1, statusWord2, error in
                    if let error = error {
                        // エラー処理
                        return
                    }
                    // statusWord の確認
                    
                    session.invalidate(doneMessage: self.configuration.doneAlertMessage)
                }
            }
        }
    }
}
#endif
