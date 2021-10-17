//
//  InfoPlistChecker.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/18.
//

import NFCKitCore

public enum InfoPlistChecker {
    public static func check() {
        func check(for key: String) {
            let value = Bundle.main.object(forInfoDictionaryKey: key) is String
            result.append((key, value))
        }
        
        var result: [(String, Bool)] = []
        
        check(for: "NFCReaderUsageDescription")
        
        guard !result.allSatisfy({ $0.1 }) else {
            return
        }
        
        print("""
        -------------------------------------------
        ℹ️ TRETNFCKit Info.plist Checker Result ℹ️
        """)
        result.forEach { key, value in
            print("\t• \(key): \(value ? "✅" : "❌")")
        }
        print("-------------------------------------------")
    }
}
