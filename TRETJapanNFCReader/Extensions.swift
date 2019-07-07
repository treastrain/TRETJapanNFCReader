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

private extension String {
    var bytes: [UInt8] {
        var i = self.startIndex
        return (0..<self.count/2).compactMap { _ in
            defer { i = self.index(i, offsetBy: 2) }
            return UInt8(self[i...index(after: i)], radix: 16)
        }
    }
    var data: Data {
        return Data(self.bytes)
    }
}

internal extension Array {
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

internal extension Optional where Wrapped == String {
    init(jisX0208Data: [[UInt8]]) {
        guard let path = JapanNFCReader.bundle.path(forResource: "JIS0208", ofType: "TXT") else {
            self = nil
            return
        }
        do {
            let tableString = try String(contentsOfFile: path, encoding: .utf8)
            let tableStringArray = tableString.components(separatedBy: .newlines)
            // var tableFromJISX0208ToShiftJIS: [Data : Data] = [:]
            var tableFromJISX0208ToUnicode: [Data : Data] = [:]
            for row in tableStringArray {
                if row.first != "#" {
                    let col = row.components(separatedBy: .whitespaces)
                    if col.count > 2 {
                        // let col0 = col[0].data
                        let col1 = col[1].data
                        let col2 = col[2].data
                        // tableFromJISX0208ToShiftJIS[col1] = col0
                        tableFromJISX0208ToUnicode[col1] = col2
                    }
                }
            }
            
            let dataArray = jisX0208Data.map { (data) -> Data in
                return (UInt16(data[1]) << 8 + UInt16(data[0])).data
            }
            var string = ""
            for data in dataArray {
                if let unicodeData = tableFromJISX0208ToUnicode[data], let s = String(data: unicodeData, encoding: .unicode) {
                    string += s
                } else {
                    switch data {
                    case Data([0xFF, 0xF1]):
                        string += "(外字1)"
                    case Data([0xFF, 0xF2]):
                        string += "(外字2)"
                    case Data([0xFF, 0xF3]):
                        string += "(外字3)"
                    case Data([0xFF, 0xF4]):
                        string += "(外字4)"
                    case Data([0xFF, 0xF5]):
                        string += "(外字5)"
                    case Data([0xFF, 0xF6]):
                        string += "(外字6)"
                    case Data([0xFF, 0xF7]):
                        string += "(外字7)"
                    case Data([0xFF, 0xFA]):
                        string += "(欠字)"
                    default:
                        string += "(未定義)"
                    }
                }
            }
            self = string
        } catch {
            self = nil
        }
    }
}

extension Data {
    
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
    
    var uint16: UInt16 {
        get {
            let i16array = self.withUnsafeBytes {
                UnsafeBufferPointer<UInt16>(start: $0, count: self.count/2).map(UInt16.init(littleEndian:))
            }
            return i16array[0]
        }
    }
}
