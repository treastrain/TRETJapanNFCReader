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
        didBeginReaderAlertMessage: NSLocalizedString("did_begin_reader_alert_message", bundle: .module, comment: ""),
        didDetectMoreThanOneTagAlertMessage: NSLocalizedString("did_detect_more_than_one_tag_alert_message", bundle: .module, comment: ""),
        didDetectMoreThanOneTagRetryInterval: .milliseconds(500),
        didDetectDifferentTagTypeAlertMessage: NSLocalizedString("did_detect_different_tag_type_alert_message", bundle: .module, comment: ""),
        didDetectDifferentTagTypeRetryInterval: .milliseconds(500),
        doneAlertMessage: NSLocalizedString("done_alert_message", bundle: .module, comment: "")
    )
    
    public var doNotReturnReaderSessionInvalidationErrorUserCanceledWhenTheProcessIsSuccessfullyCompleted: Bool
    public var didBeginReaderAlertMessage: String
    public var didDetectMoreThanOneTagAlertMessage: String
    public var didDetectMoreThanOneTagRetryInterval: DispatchTimeInterval
    public var didDetectDifferentTagTypeAlertMessage: String
    public var didDetectDifferentTagTypeRetryInterval: DispatchTimeInterval
    public var doneAlertMessage: String
}
