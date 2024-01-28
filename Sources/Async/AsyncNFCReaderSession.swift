//
//  AsyncNFCReaderSession.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

public protocol AsyncNFCReaderSession: AnyObject {
    associatedtype Event
    associatedtype EventStream
    var eventStream: EventStream { get }
    var isReady: Bool { get }
    var alertMessage: String { get set }
    func start()
    func stop()
}

#if canImport(CoreNFC)
extension AsyncNFCReaderSession {
    public static var readingAvailable: Bool { NFCReaderSession.readingAvailable }
}
#endif
