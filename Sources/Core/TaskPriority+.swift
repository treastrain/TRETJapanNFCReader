//
//  TaskPriority+.swift
//  Core
//
//  Created by treastrain on 2023/02/05.
//

import Dispatch
import Foundation

extension TaskPriority {
    @_spi(TaskPriorityToDispatchQoSClass)
    public var dispatchQoSClass: DispatchQoS.QoSClass {
        switch self {
        case .unspecified:
            return .unspecified
        case .background:
            return .background
        case .low, .utility:
            return .utility
        case .medium, .default:
            return .default
        case .high, .userInitiated:
            return .userInitiated
        case .userInteractive:
            return .userInteractive
        default:
            return .default
        }
    }
}
