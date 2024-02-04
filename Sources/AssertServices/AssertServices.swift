//
//  AssertServices.swift
//  AssertServices
//
//  Created by treastrain on 2023/01/15.
//

import Foundation

package func assertionFailure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
    AssertServices.assertionFailureHandler(message(), file, line)
}

struct AssertServices {
    static var assertionFailureHandler: (String, StaticString, UInt) -> () = assertionFailureDefaultHandler
    static let assertionFailureDefaultHandler = { Swift.assertionFailure($0, file: $1, line: $2) }
}
