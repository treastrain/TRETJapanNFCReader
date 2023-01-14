//
//  InfoPListChecker.swift
//  InfoPListChecker
//
//  Created by treastrain on 2022/11/26.
//

import Foundation

public struct InfoPListChecker {
    public static let main: Self = .init(bundle: .main)
    
    public init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    let bundle: Bundle
}

extension InfoPListChecker {
    func print(results: [(label: String, result: Bool?)]) {
        Swift.print("""
        -------------------------------------------
        ℹ️ TRETNFCKit Info.plist Checker Result ℹ️
        """)
        if results.contains(where: { $1 == false }) {
            Swift.print("The description in Info.plist is incomplete, and as it is, the App crashes when trying to use the NFC feature, or it cannot communicate with the tag properly.")
        }
        results.forEach {
            Swift.print("\($0): \($1 == nil ? "" : $1! ? "✅" : "❌")")
        }
        Swift.print("-------------------------------------------")
    }
}
