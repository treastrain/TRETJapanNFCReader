//
//  AsyncNFCNDEFMessageReaderSession.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

#if canImport(CoreNFC)
open class AsyncNFCNDEFMessageReaderSession: AsyncNFCReaderSession {
    public init(
        invalidateAfterFirstRead: Bool
    ) {
        (eventStream, eventStreamContinuation) = EventStream.makeStream()
        bridge = .init(invalidateAfterFirstRead: invalidateAfterFirstRead)
        bridge.sessionDidBecomeActive = { [unowned self] in
            eventStreamContinuation.yield(.sessionBecomeActive)
        }
        bridge.sessionDidInvalidateWithError = { [unowned self] in
            eventStreamContinuation.yield(.sessionInvalidated(reason: $0))
            eventStreamContinuation.finish()
        }
        bridge.sessionDidDetectNDEFs = { [unowned self] in
            eventStreamContinuation.yield(.sessionDetected(messages: $0))
        }
        eventStreamContinuation.yield(.sessionIsReady)
    }
    
    public let eventStream: EventStream
    
    public var isReady: Bool {
        bridge.isReady
    }
    
    public var alertMessage: String {
        get { bridge.alertMessage }
        set { bridge.alertMessage = newValue }
    }
    
    public func start() {
        bridge.begin()
        eventStreamContinuation.yield(.sessionStarted)
    }
    
    public func stop() {
        bridge.invalidate()
    }
    
    private let bridge: NFCNDEFMessageReaderSessionBridge
    private let eventStreamContinuation: EventStream.Continuation
}

extension AsyncNFCNDEFMessageReaderSession {
    public enum Event: AsyncNFCReaderSessionEvent {
        case sessionIsReady
        case sessionStarted
        case sessionBecomeActive
        case sessionDetected(messages: [NFCNDEFMessage])
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension AsyncNFCNDEFMessageReaderSession {
    public typealias EventStream = AsyncStream<Event>
}

private final class NFCNDEFMessageReaderSessionBridge: NSObject, NFCReaderSessionBridgeable, NFCNDEFReaderSessionDelegate {
    private lazy var session: NFCNDEFReaderSession = { preconditionFailure("`session` has not been set.") }()
    lazy var sessionDidBecomeActive: () -> Void = { preconditionFailure("`sessionDidBecomeActive` has not been set.") }()
    lazy var sessionDidInvalidateWithError: (_ error: NFCReaderError) -> Void = { preconditionFailure("`sessionDidInvalidateWithError` has not been set.") }()
    lazy var sessionDidDetectNDEFs: (_ messages: [NFCNDEFMessage]) -> Void = { preconditionFailure("`sessionDidDetectNDEFs` has not been set.") }()
    
    init(
        invalidateAfterFirstRead: Bool
    ) {
        super.init()
        session = .init(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: invalidateAfterFirstRead
        )
    }
    
    var isReady: Bool {
        session.isReady
    }
    
    var alertMessage: String {
        get { session.alertMessage }
        set { session.alertMessage = newValue }
    }
    
    func begin() {
        session.begin()
    }
    
    func invalidate() {
        session.invalidate()
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        sessionDidBecomeActive()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        sessionDidInvalidateWithError(error as! NFCReaderError)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        sessionDidDetectNDEFs(messages)
    }
}
#endif
