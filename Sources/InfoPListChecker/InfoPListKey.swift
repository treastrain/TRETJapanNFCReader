//
//  InfoPListKey.swift
//  InfoPListChecker
//
//  Created by treastrain on 2022/11/26.
//

import Foundation

public struct InfoPListKey<T, U> {
    public struct PossibleValue {
        public let value: U
        public let name: StaticString
    }
    
    public let key: StaticString
    public let name: StaticString
    public let type = T.self
    public let possibleValues: [PossibleValue]?
    
    init(key: StaticString, name: StaticString) where U == Never {
        self.key = key
        self.name = name
        self.possibleValues = nil
    }
    
    init(key: StaticString, name: StaticString, possibleValues: [PossibleValue]?) where T == U {
        self.key = key
        self.name = name
        self.possibleValues = possibleValues
    }
    
    init(key: StaticString, name: StaticString, possibleValues: [PossibleValue]?) where T == [U] {
        self.key = key
        self.name = name
        self.possibleValues = possibleValues
    }
    
    init<V>(key: StaticString, name: StaticString, possibleValues: [PossibleValue]?) where T == [V : U], V : Hashable {
        self.key = key
        self.name = name
        self.possibleValues = possibleValues
    }
}

extension InfoPListKey: Identifiable {
    public var id: String { "\(key)" }
}

extension InfoPListKey: Equatable {
    public static func == (lhs: InfoPListKey<T, U>, rhs: InfoPListKey<T, U>) -> Bool {
        lhs.id == rhs.id
    }
}

extension InfoPListKey: Sendable where T: Sendable, U: Sendable {}
extension InfoPListKey.PossibleValue: Sendable where U: Sendable {}
