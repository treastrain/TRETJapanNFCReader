//
//  AsyncNFCVASReaderSession.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

#if canImport(CoreNFC)
open class AsyncNFCVASReaderSession: AsyncNFCReaderSession {
    public init(
        vasCommandConfigurations: [NFCVASCommandConfiguration]
    ) {
        (eventStream, eventStreamContinuation) = EventStream.makeStream()
        bridge = .init(vasCommandConfigurations: vasCommandConfigurations)
        bridge.sessionDidBecomeActive = { [unowned self] in
            eventStreamContinuation.yield(.sessionBecomeActive)
        }
        bridge.sessionDidInvalidateWithError = { [unowned self] in
            eventStreamContinuation.yield(.sessionInvalidated(reason: $0))
            eventStreamContinuation.finish()
        }
        bridge.sessionDidReceive = { [unowned self] in
            eventStreamContinuation.yield(.sessionReceived(responses: $0))
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
    
    public func stop(errorMessage: String) {
        bridge.invalidate(errorMessage: errorMessage)
    }
    
    private let bridge: NFCVASReaderSessionBridge
    private let eventStreamContinuation: EventStream.Continuation
}

extension AsyncNFCVASReaderSession {
    public enum Event: AsyncNFCReaderSessionEvent {
        case sessionIsReady
        case sessionStarted
        case sessionBecomeActive
        case sessionReceived(responses: [NFCVASResponse])
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension AsyncNFCVASReaderSession {
    public typealias EventStream = AsyncStream<Event>
}

private final class NFCVASReaderSessionBridge: NSObject, NFCReaderSessionBridgeable, NFCVASReaderSessionDelegate {
    private lazy var session: NFCVASReaderSession = { preconditionFailure("`session` has not been set.") }()
    lazy var sessionDidBecomeActive: () -> Void = { preconditionFailure("`sessionDidBecomeActive` has not been set.") }()
    lazy var sessionDidInvalidateWithError: (_ error: NFCReaderError) -> Void = { preconditionFailure("`sessionDidInvalidateWithError` has not been set.") }()
    lazy var sessionDidReceive: (_ responses: [NFCVASResponse]) -> Void = { preconditionFailure("`sessionDidReceive` has not been set.") }()
    
    init(
        vasCommandConfigurations: [NFCVASCommandConfiguration]
    ) {
        super.init()
        session = .init(
            vasCommandConfigurations: vasCommandConfigurations,
            delegate: self,
            queue: nil
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
    
    func invalidate(errorMessage: String) {
        session.invalidate(errorMessage: errorMessage)
    }
    
    func readerSessionDidBecomeActive(_ session: NFCVASReaderSession) {
        sessionDidBecomeActive()
    }
    
    func readerSession(_ session: NFCVASReaderSession, didInvalidateWithError error: any Error) {
        sessionDidInvalidateWithError(error as! NFCReaderError)
    }
    
    func readerSession(_ session: NFCVASReaderSession, didReceive responses: [NFCVASResponse]) {
        sessionDidReceive(responses)
    }
}
#endif
