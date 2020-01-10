//
//  Extensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/06.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public extension Date {
    func toString(dateStyle: DateFormatter.Style = .full, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}

public extension Optional where Wrapped == Date {
    func toString(dateStyle: DateFormatter.Style = .full, timeStyle: DateFormatter.Style = .none) -> String? {
        return self?.toString()
    }
}

public extension UInt8 {
    func toString() -> String {
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
        return self?.toHexString()
    }
}

internal extension UInt8 {
    var data: Data {
        var int8 = self
        return Data(bytes: &int8, count: MemoryLayout<UInt8>.size)
    }
}

public extension UInt16 {
    var data: Data {
        var int16 = self
        return Data(bytes: &int16, count: MemoryLayout<UInt16>.size)
    }
    
    var uint8: [UInt8] {
        return [UInt8(self >> 8), UInt8(self & 0x00ff)]
    }
    
    func toHexString() -> String {
        let bytes = self.uint8
        return "0x" + bytes[0].toString() + bytes[1].toString()
    }
}

public extension String {
    var bytes: [UInt8] {
        var i = self.startIndex
        return (0..<self.count/2).compactMap { _ in
            defer { i = self.index(i, offsetBy: 2) }
            return UInt8(self[i...index(after: i)], radix: 16)
        }
    }
    var hexData: Data {
        return Data(self.bytes)
    }
}

public extension Array {
    func split(count: Int) -> [[Element]] {
        var s: [[Element]] = []
        var i = 0
        while i < self.count {
            var a: [Element] = []
            var j = 0
            while j < count {
                if i < self.count {
                    a.append(self[i])
                }
                i += 1
                j += 1
            }
            s.append(a)
        }
        return s
    }
}

public extension Data {
    var hexString: String {
        return self.map { String(format: "%.2hhx", $0) }.joined()
    }
    
    func toIntReversed(_ startIndex: Int, _ endIndex: Int) -> Int {
        var s = 0
        
        for (n, i) in (startIndex...endIndex).enumerated() {
            s += Int(self[i]) << (n * 8)
        }
        
        return s
    }
}
