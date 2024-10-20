//
//  NFCDetectedObjects.swift
//  Core
//
//  Created by treastrain on 2024/09/16.
//

import Foundation

protocol NFCDetectedObjects<Object>: RandomAccessCollection, CustomStringConvertible, Sendable {
    associatedtype Object
    nonisolated(unsafe) var base: [Object] { get }
}

extension NFCDetectedObjects {
    public var startIndex: Int { base.startIndex }
    
    public var endIndex: Int { base.endIndex }
    
    public func makeIterator() -> IndexingIterator<[Object]> {
        base.makeIterator()
    }
    
    public subscript(position: Int) -> Object {
        base[position]
    }
}

extension NFCDetectedObjects {
    public var description: String {
        base.description
    }
}
