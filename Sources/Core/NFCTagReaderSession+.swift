//
//  NFCTagReaderSession+.swift
//  Core
//
//  Created by treastrain on 2024/09/16.
//

#if canImport(CoreNFC)
import Foundation
public import CoreNFC

extension NFCTagReaderSession {
    public convenience init?(
        pollingOption: NFCTagReaderSession.PollingOption
    ) {
        let delegate = NFCTagReaderSessionDelegateHandleObject()
        self.init(pollingOption: pollingOption, delegate: delegate)
        self.handleObject = delegate
    }
    
    public var eventStream: AsyncStream<Event> {
        guard handleObject != nil else {
            fatalError("Must use init(pollingOption:) initializer. init(pollingOption:delegate:queue:) is not supported.")
        }
        let (stream, continuation) = AsyncStream.makeStream(of: Event.self)
        handleObject!.continuation = continuation
        begin()
        return stream
    }
}

extension NFCTagReaderSession {
    public enum Event: Sendable {
        case sessionBecomeActive
        case sessionDetected(tags: DetectedTags)
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension NFCTagReaderSession.Event {
    public struct DetectedTags: NFCDetectedObjects {
        nonisolated(unsafe) let base: [NFCTag]
    }
}

extension NFCTagReaderSession {
    private nonisolated(unsafe) static var _handleObjectKey = malloc(1)!
    
    private var handleObject: NFCTagReaderSessionDelegateHandleObject? {
        get { objc_getAssociatedObject(self, Self._handleObjectKey) as? NFCTagReaderSessionDelegateHandleObject }
        set { objc_setAssociatedObject(self, Self._handleObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private final class NFCTagReaderSessionDelegateHandleObject: NSObject, NFCTagReaderSessionDelegate {
    var continuation: AsyncStream<NFCTagReaderSession.Event>.Continuation?
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        continuation?.yield(.sessionBecomeActive)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        let tags = NFCTagReaderSession.Event.DetectedTags(base: tags)
        continuation?.yield(.sessionDetected(tags: tags))
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        continuation?.yield(.sessionInvalidated(reason: error as! NFCReaderError))
        continuation?.finish()
        continuation = nil
    }
}
#endif
