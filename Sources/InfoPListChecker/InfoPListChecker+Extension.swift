//
//  InfoPListChecker+Extension.swift
//  InfoPListChecker
//
//  Created by treastrain on 2022/11/27.
//

import Foundation

extension Bundle {
    fileprivate func object<T, U>(forInfoDictionaryKey key: InfoPListKey<T, U>) -> T? {
        object(forInfoDictionaryKey: "\(key.key)") as? T
    }
}

extension InfoPListChecker {
    public func checkNFCReaderUsageDescription() throws {
        let key = InfoPListKey.nfcReaderUsageDescription
        let result = bundle.object(forInfoDictionaryKey: key) != nil
        print(results: [(label: "\t• \(key.key)", result: result)])
        if !result { throw InfoPListChecker.Error.noRequiredValuesInInfoPlist }
    }
}
