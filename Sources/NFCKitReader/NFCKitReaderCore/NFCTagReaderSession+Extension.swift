//
//  NFCTagReaderSession+Extension.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/19.
//

#if os(iOS)
import NFCKitCore

@available(iOS 13.0, *)
extension NFCTagReaderSession {
    open func invalidate(doneMessage: String) {
        alertMessage = doneMessage
        super.invalidate()
    }
}
#endif
