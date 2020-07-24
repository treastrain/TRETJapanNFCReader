//
//  JapanNFCReaderConfiguration.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/07/25.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import Foundation

@available(iOS 13.0, *)
extension JapanNFCReader {
    
    public struct Configuration {
        
        public static let `default` = Configuration()
        private init() {}
    }
}

#endif
