//
//  FeliCaPollingRequestCode.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation

/// Request code parameter for the polling command.
public enum FeliCaPollingRequestCode : Int {
    case noRequest = 0
    case systemCode = 1
    case communicationPerformance = 2
}
