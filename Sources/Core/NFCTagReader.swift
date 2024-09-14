//
//  NFCTagReader.swift
//  Core
//
//  Created by treastrain on 2023/04/16.
//

#if canImport(CoreNFC)
public import enum CoreNFC.NFCTag

public actor NFCTagReader: Actor {
    private nonisolated(unsafe) let session: Session
    public nonisolated let taskPriority: TaskPriority?
    
    public init?(pollingOption: Session.PollingOption, delegate: any Delegate & Actor, taskPriority: TaskPriority? = nil) {
        guard let session = Session(pollingOption: pollingOption, delegate: delegate, queue: taskPriority.map { .global(qos: $0.dispatchQoSClass) }) else {
            return nil
        }
        self.session = session
        self.taskPriority = taskPriority
    }
    
    public func restartPolling() {
        session.restartPolling()
    }
    
    public var connectedTag: NFCTag? { session.connectedTag }
    
    public func connect(to tag: sending NFCTag) async throws {
        try await session.connect(to: tag)
    }
}

extension NFCTagReader: NFCReaderProtocol {
    public typealias Session = NFCTagReaderSession
    public typealias Delegate = NFCTagReaderSessionDelegate
    public typealias AfterBeginProtocol = _OpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderAfterBeginProtocol`
    
    public var delegate: AnyObject? { session.delegate }
    
    public static var readingAvailable: Bool { Session.readingAvailable }
    
    public var sessionQueue: DispatchQueue { session.sessionQueue }
    
    public func begin() {
        session.begin()
    }
}

extension NFCTagReader: NFCReaderAfterBeginProtocol {
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

extension NFCTagReader {
    public enum _OpaqueTypeBuilder: _NFCReaderOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderAfterBeginProtocol`, which will not be called from either place.
        public var afterBeginProtocol: some NFCReaderAfterBeginProtocol {
            NFCTagReader(pollingOption: [], delegate: { fatalError("Do not call this property.") }(), taskPriority: nil)!
        }
    }
}
#endif
