//
//  FeliCaPollingTimeSlot.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/16.
//

import Foundation

/// Time slot parameter for the polling command.
public enum FeliCaPollingTimeSlot : Int {
    case max1 = 0
    case max2 = 1
    case max4 = 3
    case max8 = 7
    case max16 = 15
}
