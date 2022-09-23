//
//  NFCNDEFMessageReader+DetectMessageResult.swift
//  Core
//
//  Created by treastrain on 2022/09/23.
//

import Foundation

extension NFCNDEFMessageReader {
    public enum DetectMessageResult: Sendable {
        case success(alertMessage: String?)
        case restartPolling(alertMessage: String?)
        case `continue`
    }
}

extension NFCNDEFMessageReader.DetectMessageResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
}
