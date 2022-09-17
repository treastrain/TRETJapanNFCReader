//
//  TLVField.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/05/11.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

public struct TLVField {
    /// タグ
    public var tag: [UInt8]
    /// 長さ
    public var length: Int
    /// データ
    public var value: [UInt8]
    
    static public func sequenceOfFields(from data: Data) -> [TLVField] {
        var fields: [TLVField] = []
        
        var i = 0
        while i < data.count {
            if data[i] == 0xFF {
                break
            }
            var tag = [data[i]]
            if tag.first! == 0x5F {
                i += 1
                tag.append(data[i])
            }
            i += 1
            var length = UInt16(data[i])
            if length == 0 {
                i += 1
                continue
            }
            if length == 0x82 {
                i += 1
                length = UInt16(data[i]) << 8 + UInt16(data[i + 1])
                i += 1
            }
            i += 1
            let endIndex = Int(length) + i - 1
            let value = data[i...endIndex].map {$0}
            i = endIndex + 1
            
            // let valueString = value.map { (u) -> String in u.toHexString() }
            // print("タグ: \(tag.toHexString()), 長さ: \(length), 値: \(valueString)")
            
            fields.append(TLVField(tag: tag, length: Int(length), value: value))
        }
        
        return fields
    }
    
    static public func sequenceOfFields(from data: [UInt8]) -> [TLVField] {
        self.sequenceOfFields(from: Data(data))
    }
}
