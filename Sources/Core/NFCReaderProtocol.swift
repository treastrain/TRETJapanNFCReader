//
//  NFCReaderProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
public protocol NFCReaderProtocol: Actor {
    associatedtype Session: NFCReaderSessionProtocol
    associatedtype Delegate
    associatedtype AfterBeginProtocol: NFCReaderAfterBeginProtocol
    
    var taskPriority: TaskPriority? { get }
    var delegate: AnyObject? { get }
    static var readingAvailable: Bool { get }
    var sessionQueue: DispatchQueue { get }
    var isReady: Bool { get }
    var alertMessage: String { get set }
    func set(alertMessage: String)
    func begin()
    func invalidate()
}
#endif

#if canImport(CoreNFC)
public protocol _NFCReaderOpaqueTypeBuilderProtocol {
    associatedtype AfterBeginProtocol: NFCReaderAfterBeginProtocol
    var afterBeginProtocol: AfterBeginProtocol { get }
}
#endif
