//
//  NFCKitReaderConfiguration.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/17.
//

import NFCKitCore

public struct NFCKitReaderConfiguration {
    public static var `default`: Self = .init(
        doNotReturnReaderSessionInvalidationErrorUserCanceledWhenTheProcessIsSuccessfullyCompleted: true,
        didBeginReaderAlertMessage: NSLocalizedString("did_begin_reader_alert_message", bundle: .module, comment: "")
    )
    
    public var doNotReturnReaderSessionInvalidationErrorUserCanceledWhenTheProcessIsSuccessfullyCompleted: Bool
    public var didBeginReaderAlertMessage: String
}
