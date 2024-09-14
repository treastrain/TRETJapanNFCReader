//
//  NFCNDEFReader.swift
//  Core
//
//  Created by treastrain on 2023/04/16.
//

#if canImport(CoreNFC)
public import protocol CoreNFC.NFCNDEFTag

public actor NFCNDEFReader: Actor {
    private nonisolated(unsafe) let session: Session
    public nonisolated let taskPriority: TaskPriority?
    
    public init(delegate: any Delegate & Actor, taskPriority: TaskPriority?, invalidateAfterFirstRead: Bool) {
        session = .init(delegate: delegate, queue: taskPriority.map { .global(qos: $0.dispatchQoSClass) }, invalidateAfterFirstRead: invalidateAfterFirstRead)
        self.taskPriority = taskPriority
    }
    
    public func restartPolling() {
        session.restartPolling()
    }
    
    public func connect(to tag: sending any NFCNDEFTag) async throws {
        try await session.connect(to: tag)
    }
}

extension NFCNDEFReader: NFCReaderProtocol {
    public typealias Session = NFCNDEFReaderSession
    public typealias Delegate = NFCNDEFReaderSessionDelegate
    public typealias AfterBeginProtocol = _OpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderAfterBeginProtocol`
    
    public var delegate: AnyObject? { session.delegate }
    
    public static var readingAvailable: Bool { Session.readingAvailable }
    
    public var sessionQueue: DispatchQueue { session.sessionQueue }
    
    public func begin() {
        session.begin()
    }
}

extension NFCNDEFReader: NFCReaderAfterBeginProtocol {
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

extension NFCNDEFReader {
    public enum _OpaqueTypeBuilder: _NFCReaderOpaqueTypeBuilderProtocol {
        /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderAfterBeginProtocol`, which will not be called from either place.
        public var afterBeginProtocol: some NFCReaderAfterBeginProtocol {
            NFCNDEFReader(delegate: { fatalError("Do not call this property.") }(), taskPriority: nil, invalidateAfterFirstRead: false)
        }
    }
}
#endif
