//
//  TaskPriority+Tests.swift
//  CoreTests
//
//  Created by treastrain on 2023/02/05.
//

public import Dispatch
import Foundation
import XCTest

@testable import TRETNFCKit_Core

final class TaskPriority_Tests: XCTestCase {
    func testTaskPriorityDispatchQoSClass() throws {
        #if os(Linux)
        throw XCTSkip("DispatchQoS.QoSClass.rawValue is internal on Linux.")
        #else
        for priority in TaskPriority.allCases {
            let priorityRawValue = UInt32(priority.rawValue)
            let qoSClassRawValue = priority.dispatchQoSClass.rawValue.rawValue
            XCTAssertEqual(priorityRawValue, qoSClassRawValue, "\(priority.debugDescription)(\(priorityRawValue)) is not equal to \(priority.dispatchQoSClass.debugDescription)(\(qoSClassRawValue))")
        }
        #endif
    }
}

extension TaskPriority: CaseIterable {
    public static let allCases: [Self] = [
        .unspecified,
        .background,
        .low,
        .utility,
        .medium,
        .default,
        .high,
        .userInitiated,
        .userInteractive,
    ]
}

extension TaskPriority: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .background:
            return "background"
        case .low:
            return "low"
        case .utility:
            return "utility" // but it returns "low"
        case .medium:
            return "medium"
        case .default:
            return "default" // but it returns "medium"
        case .high:
            return "high"
        case .userInitiated:
            return "userInitiated" // but it returns "userInitiated"
        case .userInteractive:
            return "userInteractive"
        default:
            return "Unknown"
        }
    }
}

extension DispatchQoS.QoSClass: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .background:
            return "background"
        case .utility:
            return "utility"
        case .default:
            return "default"
        case .userInitiated:
            return "userInitiated"
        case .userInteractive:
            return "userInteractive"
        @unknown default:
            return "Unknown"
        }
    }
}
