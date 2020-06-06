//
//  ASN1PartialParser.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/06/06.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

/*
 jpki/myna - https://github.com/jpki/myna - MIT Licence
 jpki/myna/libmyna/utils.go を参考に実装

 MIT License

 Copyright (c) 2017 HAMANO Tsukasa <hamano@osstech.co.jp>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

public struct ASN1PartialParser {
    public private(set) var offset = 0
    public private(set) var length = 0
    
    public var size: Int {
        return self.offset + self.length
    }
    
    public init(data: Data) throws {
        try self.parseTag(data: data)
        try self.parseLength(data: data)
    }
    
    private mutating func parseTag(data: Data) throws {
        let data = data as NSData
        var offset = 1
        if data.length < 2 {
            throw NSError()
        }
        if data[0] & 0x1F == 0x1F {
            offset += 1
            if data.length < 2 || data[1] & 0x80 != 0 {
                throw NSError()
            }
        }
        self.offset = offset
    }
    
    private mutating func parseLength(data: Data) throws {
        let data = data as NSData
        if self.offset >= data.length {
            throw NSError()
        }
        var b = data[self.offset]
        self.offset += 1
        if b & 0x80 == 0 {
            self.length = Int(b)
        } else {
            let lol = b & 0x7F
            for _ in 0..<lol {
                if self.offset >= data.length {
                    throw NSError()
                }
                b = data[self.offset]
                self.offset += 1
                self.length <<= 8
                self.length |= Int(b)
            }
        }
    }
}
