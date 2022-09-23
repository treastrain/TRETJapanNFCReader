//
//  NFCNDEFTagReader+DetectTagResult.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

import Foundation

extension NFCNDEFTagReader {
    public enum DetectTagResult: Sendable {
        case success(alertMessage: String?)
        case failure(errorMessage: String)
        case restartPolling(alertMessage: String?)
        case none
    }
}

extension NFCNDEFTagReader.DetectTagResult {
    public static var success: Self = .success(alertMessage: nil)
    public static var restartPolling: Self = .restartPolling(alertMessage: nil)
    
    public static func failure(with error: Error) -> Self {
        .failure(errorMessage: error.localizedDescription)
    }
}
