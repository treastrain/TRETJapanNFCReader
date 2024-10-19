//
//  NFCNDEFReaderSession+.swift
//  Core
//
//  Created by treastrain on 2024/09/16.
//

#if canImport(CoreNFC)
import Foundation
public import CoreNFC

extension NFCNDEFReaderSession {
    public convenience init(
        of detectionType: DetectionType,
        invalidateAfterFirstRead: Bool
    ) {
        let delegate: any NFCNDEFReaderSessionDelegateHandleObject
        switch detectionType {
        case .messages:
            delegate = NFCNDEFReaderSessionDelegateHandleObjectForMessage()
        case .tags:
            delegate = NFCNDEFReaderSessionDelegateHandleObjectForTag()
        }
        self.init(delegate: delegate, queue: nil, invalidateAfterFirstRead: invalidateAfterFirstRead)
        self.handleObject = delegate
    }
    
    public var messageEventStream: AsyncStream<MessageEvent> {
        guard handleObject != nil else {
            fatalError("Must use init(of:invalidateAfterFirstRead:) initializer. init(delegate:queue:invalidateAfterFirstRead:) is not supported.")
        }
        guard (handleObject as? NFCNDEFReaderSessionDelegateHandleObjectForMessage) != nil else {
            fatalError("This property is available only when `detectionType` is `.messages`.")
        }
        let (stream, continuation) = AsyncStream.makeStream(of: MessageEvent.self)
        (handleObject as! NFCNDEFReaderSessionDelegateHandleObjectForMessage).continuation = continuation
        begin()
        return stream
    }
    
    public var tagEventStream: AsyncStream<TagEvent> {
        guard handleObject != nil else {
            fatalError("Must use init(of:invalidateAfterFirstRead:) initializer. init(delegate:queue:invalidateAfterFirstRead:) is not supported.")
        }
        guard (handleObject as? NFCNDEFReaderSessionDelegateHandleObjectForTag) != nil else {
            fatalError("This property is available only when `detectionType` is `.tags`.")
        }
        let (stream, continuation) = AsyncStream.makeStream(of: TagEvent.self)
        (handleObject as! NFCNDEFReaderSessionDelegateHandleObjectForTag).continuation = continuation
        begin()
        return stream
    }
}

extension NFCNDEFReaderSession {
    public enum DetectionType: Sendable {
        case messages
        case tags
    }
}

extension NFCNDEFReaderSession {
    public enum MessageEvent: Sendable {
        case sessionBecomeActive
        case sessionDetected(messages: DetectedMessages)
        case sessionInvalidated(reason: NFCReaderError)
    }
    
    public enum TagEvent: Sendable {
        case sessionBecomeActive
        case sessionDetected(tags: DetectedTags)
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension NFCNDEFReaderSession {
    public struct DetectedMessages: NFCDetectedObjects {
        nonisolated(unsafe) var base: [NFCNDEFMessage]
    }
    
    public struct DetectedTags: NFCDetectedObjects {
        nonisolated(unsafe) let base: [any NFCNDEFTag]
    }
}

extension NFCNDEFReaderSession {
    private nonisolated(unsafe) static var _handleObjectKey = malloc(1)!
    
    private var handleObject: (any NFCNDEFReaderSessionDelegateHandleObject)? {
        get { objc_getAssociatedObject(self, Self._handleObjectKey) as? (any NFCNDEFReaderSessionDelegateHandleObject) }
        set { objc_setAssociatedObject(self, Self._handleObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private protocol NFCNDEFReaderSessionDelegateHandleObject: NSObject, NFCNDEFReaderSessionDelegate {}

private final class NFCNDEFReaderSessionDelegateHandleObjectForMessage: NSObject, NFCNDEFReaderSessionDelegateHandleObject {
    var continuation: AsyncStream<NFCNDEFReaderSession.MessageEvent>.Continuation?
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        continuation?.yield(.sessionBecomeActive)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        let messages = NFCNDEFReaderSession.DetectedMessages(base: messages)
        continuation?.yield(.sessionDetected(messages: messages))
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        continuation?.yield(.sessionInvalidated(reason: error as! NFCReaderError))
        continuation?.finish()
        continuation = nil
    }
}

private final class NFCNDEFReaderSessionDelegateHandleObjectForTag: NSObject, NFCNDEFReaderSessionDelegateHandleObject {
    var continuation: AsyncStream<NFCNDEFReaderSession.TagEvent>.Continuation?
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        continuation?.yield(.sessionBecomeActive)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("This method should not be called.")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
        print(tags)
        let tags = NFCNDEFReaderSession.DetectedTags(base: tags)
        continuation?.yield(.sessionDetected(tags: tags))
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: any Error) {
        continuation?.yield(.sessionInvalidated(reason: error as! NFCReaderError))
        continuation?.finish()
        continuation = nil
    }
}
#endif
