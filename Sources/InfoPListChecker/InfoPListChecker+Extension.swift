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
