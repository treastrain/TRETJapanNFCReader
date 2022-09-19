//
//  NFCTagReader+DetectTagResult.swift
//  Core
//
//  Created by treastrain on 2022/09/20.
//

import Foundation

extension NFCTagReader {
    public enum DetectTagResult: Sendable {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
    }
}

extension NFCTagReader.DetectTagResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}
