//
//  InfoPlistChecker.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/10/18.
//

import NFCKitCore

public enum InfoPlistCheckerError: LocalizedError {
    case noRequiredValuesInInfoPlist
    
    public var errorDescription: String? {
        switch self {
        case .noRequiredValuesInInfoPlist:
            return "Could not find (any) required key-value(s) in Info.plist. Check the results of the \"TRETNFCKit Info.plist Checker\"."
        }
    }
}

public enum InfoPlistChecker {
    public static func check(forISO7816ApplicationIdentifiers applicationIdentifiers: [String]) -> Result<Void, InfoPlistCheckerError> {
        check(with: [(key: "com.apple.developer.nfc.readersession.iso7816.select-identifiers", values: applicationIdentifiers)])
    }
    
    public static func check(with requiredArrays: [(key: String, values: [String])]) -> Result<Void, InfoPlistCheckerError> {
        func check(for key: String) {
            let value = Bundle.main.object(forInfoDictionaryKey: key) is String
            result.append(("\t• \(key)", value))
        }
        
        func check(for keyAndValues: (key: String, values: [String])) {
            let values = Bundle.main.object(forInfoDictionaryKey: keyAndValues.key) as? [String] ?? []
            result.append(("\t• \(keyAndValues.key)", nil))
            zip(keyAndValues.values.indices, keyAndValues.values).forEach { index, value in
                result.append(("\t\t• Item \(index): \"\(value)\"", values.contains(value)))
            }
        }
        
        var result: [(String, Bool?)] = []
        
        check(for: "NFCReaderUsageDescription")
        requiredArrays.forEach { requiredArray in
            check(for: requiredArray)
        }
        
        guard !result.allSatisfy({ $0.1 ?? true }) else {
            return .success(())
        }
        
        print("""
        -------------------------------------------
        ℹ️ TRETNFCKit Info.plist Checker Result ℹ️
        """)
        result.forEach { key, value in
            print("\(key): \(value == nil ? "" : value! ? "✅" : "❌")")
        }
        print("-------------------------------------------")
        return .failure(.noRequiredValuesInInfoPlist)
    }
}
