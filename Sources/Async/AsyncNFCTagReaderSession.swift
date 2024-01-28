//
//  AsyncNFCTagReaderSession.swift
//  Async
//
//  Created by treastrain on 2024/01/28.
//

#if canImport(CoreNFC)
open class AsyncNFCTagReaderSession: AsyncNFCReaderSession {
    public init(
        pollingOption: NFCTagReaderSession.PollingOption
    ) {
        (eventStream, eventStreamContinuation) = EventStream.makeStream()
        bridge = .init(pollingOption: pollingOption)
        guard let bridge else {
            eventStreamContinuation.yield(
                .sessionCreationFailed(
                    reason: pollingOption.isEmpty ? .pollingOptionIsEmpty : .systemNotAvailable
                )
            )
            eventStreamContinuation.finish()
            return
        }
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
        bridge?.isReady ?? false
    }
    
    public var alertMessage: String {
        get { bridge?.alertMessage ?? "" }
        set {
            guard let bridge = assertedBridge() else { return }
            bridge.alertMessage = newValue
        }
    }
    
    public func start() {
        guard let bridge = assertedBridge() else { return }
        bridge.begin()
        eventStreamContinuation.yield(.sessionStarted)
    }
    
    public var connectedTag: NFCTag? {
        guard let bridge = assertedBridge() else { return nil }
        return bridge.connectedTag
    }
    
    public func connect(to tag: NFCTag) async throws {
        guard let bridge = assertedBridge() else { return }
        try await bridge.connect(to: tag)
    }
    
    public func stop() {
        guard let bridge = assertedBridge() else { return }
        bridge.invalidate()
    }
    
    public func stop(errorMessage: String) {
        guard let bridge = assertedBridge() else { return }
        bridge.invalidate(errorMessage: errorMessage)
    }
    
    private let eventStreamContinuation: EventStream.Continuation
    private let bridge: NFCTagReaderSessionBridge?
    
    private func assertedBridge(
        file: StaticString = #file,
        line: UInt = #line
    ) -> NFCTagReaderSessionBridge? {
        guard let bridge else {
            assertionFailure("Please check the `reason` from `.sessionCreationFailed(reason:)` sent to `eventStream`.", file: file, line: line)
            return nil
        }
        return bridge
    }
}

extension AsyncNFCTagReaderSession {
    public enum Event: AsyncNFCReaderSessionEvent {
        public enum SessionCreationFailedReason: Sendable {
            case pollingOptionIsEmpty
            case systemNotAvailable
        }
        
        case sessionIsReady
        case sessionStarted
        case sessionBecomeActive
        case sessionDetected(tags: [NFCTag])
        case sessionCreationFailed(reason: SessionCreationFailedReason)
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension AsyncNFCTagReaderSession {
    public typealias EventStream = AsyncStream<Event>
}

private final class NFCTagReaderSessionBridge: NSObject, NFCReaderSessionBridgeable, NFCTagReaderSessionDelegate {
    private lazy var session: NFCTagReaderSession = { preconditionFailure("`session` has not been set.") }()
    lazy var sessionDidBecomeActive: () -> Void = { preconditionFailure("`sessionDidBecomeActive` has not been set.") }()
    lazy var sessionDidInvalidateWithError: (_ error: NFCReaderError) -> Void = { preconditionFailure("`sessionDidInvalidateWithError` has not been set.") }()
    lazy var sessionDidDetect: (_ tags: [NFCTag]) -> Void = { preconditionFailure("`sessionDidDetect` has not been set.") }()
    
    init?(
        pollingOption: NFCTagReaderSession.PollingOption
    ) {
        super.init()
        guard let session = NFCTagReaderSession(
            pollingOption: pollingOption,
            delegate: self,
            queue: nil
        ) else {
            return nil
        }
        self.session = session
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
    
    var connectedTag: NFCTag? {
        session.connectedTag
    }
    
    func connect(to tag: NFCTag) async throws {
        try await session.connect(to: tag)
    }
    
    func invalidate() {
        session.invalidate()
    }
    
    func invalidate(errorMessage: String) {
        session.invalidate(errorMessage: errorMessage)
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        sessionDidBecomeActive()
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        sessionDidInvalidateWithError(error as! NFCReaderError)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        sessionDidDetect(tags)
    }
}
#endif
