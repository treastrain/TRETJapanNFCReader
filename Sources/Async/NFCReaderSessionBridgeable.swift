//
//  NFCReaderSessionBridgeable.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

protocol NFCReaderSessionBridgeable: AnyObject {
    associatedtype Error
    var sessionDidBecomeActive: () -> Void { get set }
    var sessionDidInvalidateWithError: (_ error: Error) -> Void { get set }
    var isReady: Bool { get }
    var alertMessage: String { get set }
    func begin()
    func invalidate()
}
