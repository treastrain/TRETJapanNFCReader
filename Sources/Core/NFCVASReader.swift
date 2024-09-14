//
//  NFCVASReader.swift
//  Core
//
//  Created by treastrain on 2023/04/16.
//

#if canImport(CoreNFC)
public import class CoreNFC.NFCVASCommandConfiguration

public actor NFCVASReader: Actor {
    private let session: Session
    public nonisolated let taskPriority: TaskPriority?
    
    public init(vasCommandConfigurations commandConfigurations: [NFCVASCommandConfiguration], delegate: any Delegate & Actor, taskPriority: TaskPriority?) {
        self.session = .init(vasCommandConfigurations: commandConfigurations, delegate: delegate, queue: taskPriority.map { .global(qos: $0.dispatchQoSClass) })
        self.taskPriority = taskPriority
    }
}

extension NFCVASReader: NFCReaderProtocol {
    public typealias Session = NFCVASReaderSession
    public typealias Delegate = NFCVASReaderSessionDelegate
    public typealias AfterBeginProtocol = _OpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderAfterBeginProtocol`
    
    public var delegate: AnyObject? { session.delegate }
    
    public static var readingAvailable: Bool { Session.readingAvailable }
    
    public var sessionQueue: DispatchQueue { session.sessionQueue }
    
    public func begin() {
        session.begin()
    }
}

extension NFCVASReader: NFCReaderAfterBeginProtocol {
    public var isReady: Bool { session.isReady }
    
    public var alertMessage: String {
        get {
            session.alertMessage
        }
        set {
            session.alertMessage = newValue
        }
    }
    
    public func set(alertMessage: String) {
        self.alertMessage = alertMessage
    }
    
    public func invalidate() {
        session.invalidate()
    }
    
    public func invalidate(errorMessage: String) {
        session.invalidate(errorMessage: errorMessage)
    }
}

extension NFCVASReader {
    public enum _OpaqueTypeBuilder: _NFCReaderOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderAfterBeginProtocol`, which will not be called from either place.
        public var afterBeginProtocol: some NFCReaderAfterBeginProtocol {
            NFCVASReader(vasCommandConfigurations: [], delegate: { fatalError("Do not call this property.") }(), taskPriority: nil)
        }
    }
}
#endif
