//
//  AssertServices.swift
//  AssertServices
//
//  Created by treastrain on 2023/01/15.
//

import Foundation

@_spi(AssertServices)
@inlinable public func assertionFailure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
    AssertServices.assertionFailureHandler(message(), file, line)
}

@_spi(AssertServices)
public struct AssertServices {
    public static var assertionFailureHandler: (String, StaticString, UInt) -> () = assertionFailureDefaultHandler
    static let assertionFailureDefaultHandler = { Swift.assertionFailure($0, file: $1, line: $2) }
}
