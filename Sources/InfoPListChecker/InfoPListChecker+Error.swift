//
//  InfoPListChecker+Error.swift
//  InfoPListChecker
//
//  Created by treastrain on 2022/11/27.
//

public import Foundation

extension InfoPListChecker {
    public enum Error: LocalizedError {
        case noRequiredValuesInInfoPlist
        
        public var errorDescription: String? {
            switch self {
            case .noRequiredValuesInInfoPlist:
                return "Could not find (any) required key-value(s) in Info.plist. Check the results of the \"TRETNFCKit Info.plist Checker\"."
            }
        }
    }
}
