//
//  NFCVASReaderSession+.swift
//  Core
//
//  Created by treastrain on 2024/09/16.
//

#if canImport(CoreNFC)
import Foundation
public import CoreNFC

extension NFCVASReaderSession {
    public convenience init(
        vasCommandConfigurations: [NFCVASCommandConfiguration]
    ) {
        let delegate = NFCVASReaderSessionDelegateHandleObject()
        self.init(vasCommandConfigurations: vasCommandConfigurations, delegate: delegate, queue: nil)
        self.handleObject = delegate
    }
    
    public var eventStream: AsyncStream<Event> {
        guard handleObject != nil else {
            fatalError("Must use init(vasCommandConfigurations:) initializer. init(vasCommandConfigurations:delegate:queue:) is not supported.")
        }
        let (stream, continuation) = AsyncStream.makeStream(of: Event.self)
        handleObject!.continuation = continuation
        begin()
        return stream
    }
}

extension NFCVASReaderSession {
    public enum Event: Sendable {
        case sessionBecomeActive
        case sessionReceived(responses: [NFCVASResponse])
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension NFCVASResponse: @retroactive @unchecked Sendable {}

extension NFCVASReaderSession {
    private nonisolated(unsafe) static var _handleObjectKey = malloc(1)!
    
    private var handleObject: NFCVASReaderSessionDelegateHandleObject? {
        get { objc_getAssociatedObject(self, Self._handleObjectKey) as? NFCVASReaderSessionDelegateHandleObject }
        set { objc_setAssociatedObject(self, Self._handleObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private final class NFCVASReaderSessionDelegateHandleObject: NSObject, NFCVASReaderSessionDelegate {
    var continuation: AsyncStream<NFCVASReaderSession.Event>.Continuation?
    
    func readerSessionDidBecomeActive(_ session: NFCVASReaderSession) {
        continuation?.yield(.sessionBecomeActive)
    }
    
    func readerSession(_ session: NFCVASReaderSession, didReceive responses: [NFCVASResponse]) {
        continuation?.yield(.sessionReceived(responses: responses))
    }
    
    func readerSession(_ session: NFCVASReaderSession, didInvalidateWithError error: any Error) {
        continuation?.yield(.sessionInvalidated(reason: error as! NFCReaderError))
        continuation?.finish()
        continuation = nil
    }
}
#endif
