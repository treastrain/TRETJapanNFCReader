//
//  AsyncNFCNDEFTagReaderSession.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

#if canImport(CoreNFC)
open class AsyncNFCNDEFTagReaderSession: AsyncNFCReaderSession {
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
        bridge.sessionDidDetect = { [unowned self] in
            eventStreamContinuation.yield(.sessionDetected(tags: $0))
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
    
    public func connect(to tag: any NFCNDEFTag) async throws {
        try await bridge.connect(to: tag)
    }
    
    public func stop() {
        bridge.invalidate()
    }
    
    public func stop(errorMessage: String) {
        bridge.invalidate(errorMessage: errorMessage)
    }
    
    private let bridge: NFCNDEFTagReaderSessionBridge
    private let eventStreamContinuation: EventStream.Continuation
}

extension AsyncNFCNDEFTagReaderSession {
    public enum Event: AsyncNFCReaderSessionEvent {
        case sessionIsReady
        case sessionStarted
        case sessionBecomeActive
        case sessionDetected(tags: [any NFCNDEFTag])
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension AsyncNFCNDEFTagReaderSession {
    public typealias EventStream = AsyncStream<Event>
}

private final class NFCNDEFTagReaderSessionBridge: NSObject, NFCReaderSessionBridgeable, NFCNDEFReaderSessionDelegate {
    private lazy var session: NFCNDEFReaderSession = { preconditionFailure("`session` has not been set.") }()
    lazy var sessionDidBecomeActive: () -> Void = { preconditionFailure("`sessionDidBecomeActive` has not been set.") }()
    lazy var sessionDidInvalidateWithError: (_ error: NFCReaderError) -> Void = { preconditionFailure("`sessionDidInvalidateWithError` has not been set.") }()
    lazy var sessionDidDetect: (_ tags: [any NFCNDEFTag]) -> Void = { preconditionFailure("`sessionDidDetect` has not been set.") }()
    
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
    
    func connect(to tag: any NFCNDEFTag) async throws {
        try await session.connect(to: tag)
    }
    
    func invalidate() {
        session.invalidate()
    }
    
    func invalidate(errorMessage: String) {
        session.invalidate(errorMessage: errorMessage)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        sessionDidBecomeActive()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        sessionDidInvalidateWithError(error as! NFCReaderError)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("The reader session doesn't call this method when the bridge provides the readerSession(_:didDetect:) method.")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
        sessionDidDetect(tags)
    }
}
#endif
