//
//  Extensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/06.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == Date {
    func toString(dateStyle: DateFormatter.Style = .full, timeStyle: DateFormatter.Style = .none) -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        if self == nil {
            return nil
        } else {
            return formatter.string(from: self!)
        }
    }
}

public extension UInt8 {
    func toString() -> String{
        var str = String(self, radix: 16).uppercased()
        if str.count == 1 {
            str = "0" + str
        }
        return str
    }
    
    func toHexString() -> String {
        var str = self.toString()
        str = "0x\(str)"
        return str
    }
}

public extension Optional where Wrapped == UInt8 {
    func toHexString() -> String? {
        if self == nil {
            return nil
        } else {
            return self!.toHexString()
        }
    }
}

internal extension UInt8 {
    var data: Data {
        var int8 = self
        return Data(bytes: &int8, count: MemoryLayout<UInt8>.size)
    }
}

internal extension UInt16 {
    var data: Data {
        var int16 = self
        return Data(bytes: &int16, count: MemoryLayout<UInt16>.size)
    }
}

