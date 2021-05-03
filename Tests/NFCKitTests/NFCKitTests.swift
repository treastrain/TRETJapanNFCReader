//
//  NFCKitTests.swift
//
//
//  Created by treastrain on 2021/02/19.
//

import XCTest
@testable import NFCKit

public protocol NFCKitTests: XCTestCase {
    func testObjectConsistency(_ coreSubject: Any, _ kitSubject: Any, coreChildValueHandler: ((Mirror.Child) -> AnyObject?)?, kitChildValueHandler: ((Mirror.Child) -> AnyObject?)?, file: StaticString, line: UInt)
}

public extension NFCKitTests {
    /// Test for consistency between the corresponding objects in Core NFC and NFCKit.
    /// - Parameters:
    ///   - coreSubject: A Core NFC object.
    ///   - kitSubject: A NFCKit object.
    ///   - coreChildValueHandler: A handler used to retrieve a value from a property on the Core NFC object. If you set this handler `nil`, or return `nil` in the handler, by default it retrieves the object's `Mirror.Child.value`.
    ///   - kitChildValueHandler: A handler used to retrieve a value from a property on the NFCKit object. If you set this handler `nil`, or return `nil` in the handler, by default it retrieves the object's `Mirror.Child.value`.
    ///   - file: The file in which the failure occurred. The default is the file name of the test case in which this function was called.
    ///   - line: The line number on which the failure occurred. The default is the line number on which this function was called.
    func testObjectConsistency(_ coreSubject: Any, _ kitSubject: Any, coreChildValueHandler: ((Mirror.Child) -> AnyObject?)? = nil, kitChildValueHandler: ((Mirror.Child) -> AnyObject?)? = nil, file: StaticString = #filePath, line: UInt = #line) {
        let coreMirror = Mirror(reflecting: coreSubject)
        let kitMirror = Mirror(reflecting: kitSubject)
        
        testObjectNameConsistency(coreMirror, kitMirror, file: file, line: line)
        testPropertiesConsistency(coreMirror, kitMirror, coreChildValueHandler: coreChildValueHandler, kitChildValueHandler: kitChildValueHandler, file: file, line: line)
    }
    
    private func testObjectNameConsistency(_ coreMirror: Mirror, _ kitMirror: Mirror, file: StaticString = #filePath, line: UInt = #line) {
        let coreObjectName = "\(coreMirror.subjectType)"
        let coreObjectNameWithoutPrefix = coreObjectName
            .replacingOccurrences(of: "NFC", with: "") // Match the object name without the `NFC` prefix in Core NFC with the one in NFCKit.
            .replacingOccurrences(of: "related decl 'e' for ", with: "") // `NSError` in Core NFC shall not be included in NFCKit.
        let kitObjectName = "\(kitMirror.subjectType)"
        
        XCTAssertEqual(coreObjectNameWithoutPrefix, kitObjectName, "Inconsistent class/struct names: \(coreObjectName) vs. \(kitObjectName)", file: file, line: line)
    }
    
    private func testPropertiesConsistency(_ coreMirror: Mirror, _ kitMirror: Mirror, coreChildValueHandler: ((Mirror.Child) -> AnyObject?)? = nil, kitChildValueHandler: ((Mirror.Child) -> AnyObject?)? = nil, file: StaticString = #filePath, line: UInt = #line) {
        let defaultChildValueHandler: ((Mirror.Child) -> AnyObject) = { (child) -> AnyObject in
            child.value as AnyObject
        }
        
        let coreChildren = coreMirror.children
        let kitChildren = kitMirror.children
        
        for coreChild in coreChildren {
            guard coreChild.label != "_nsError" else {
                // `NSError` in Core NFC shall not be included in NFCKit.
                XCTAssertTrue(true)
                continue
            }
            let coreChildValue = coreChildValueHandler?(coreChild) ?? defaultChildValueHandler(coreChild)
            let result = kitChildren.contains { kitChild -> Bool in
                let kitChildValue = kitChildValueHandler?(kitChild) ?? defaultChildValueHandler(kitChild)
                return coreChild.label == kitChild.label && coreChildValue === kitChildValue
            }
            XCTAssertTrue(result, "\(kitMirror.subjectType) has no member \"\(coreChild.label ?? "nil")\" or the value doesn't match. ", file: file, line: line)
        }
    }
}
