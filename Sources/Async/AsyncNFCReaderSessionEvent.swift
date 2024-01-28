//
//  AsyncNFCReaderSessionEvent.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

public protocol AsyncNFCReaderSessionEvent {
    associatedtype Error
    static var sessionIsReady: Self { get }
    static var sessionStarted: Self { get }
    static var sessionBecomeActive: Self { get }
    static func sessionInvalidated(reason: Error) -> Self
}
