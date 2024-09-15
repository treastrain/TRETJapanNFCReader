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
    
    public var eventStream: AsyncStream<Event> {
        guard handleObject != nil else {
            fatalError("Must use init(of:invalidateAfterFirstRead:) initializer. init(delegate:queue:invalidateAfterFirstRead:) is not supported.")
        }
        let (stream, continuation) = AsyncStream.makeStream(of: Event.self)
        handleObject!.continuation = continuation
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
    public enum Event: Sendable {
        case sessionBecomeActive
        case sessionDetected(messages: DetectedMessages)
        case sessionDetected(tags: DetectedTags)
        case sessionInvalidated(reason: NFCReaderError)
    }
}

extension NFCNDEFReaderSession {
    public struct DetectedMessages: RandomAccessCollection, Sendable {
        nonisolated(unsafe) let base: [NFCNDEFMessage]
        
        public var startIndex: Int { base.startIndex }
        
        public var endIndex: Int { base.endIndex }
        
        public func makeIterator() -> IndexingIterator<[NFCNDEFMessage]> {
            base.makeIterator()
        }
        
        public subscript(position: Int) -> NFCNDEFMessage {
            base[position]
        }
    }
}

extension NFCNDEFReaderSession {
    public struct DetectedTags: RandomAccessCollection, Sendable {
        nonisolated(unsafe) let base: [any NFCNDEFTag]
        
        public var startIndex: Int { base.startIndex }
        
        public var endIndex: Int { base.endIndex }
        
        public func makeIterator() -> IndexingIterator<[any NFCNDEFTag]> {
            base.makeIterator()
        }
        
        public subscript(position: Int) -> any NFCNDEFTag {
            base[position]
        }
    }
}

extension NFCNDEFReaderSession {
    private nonisolated(unsafe) static var _handleObjectKey = malloc(1)!
    
    private var handleObject: (any NFCNDEFReaderSessionDelegateHandleObject)? {
        get { objc_getAssociatedObject(self, Self._handleObjectKey) as? (any NFCNDEFReaderSessionDelegateHandleObject) }
        set { objc_setAssociatedObject(self, Self._handleObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

private protocol NFCNDEFReaderSessionDelegateHandleObject: NSObject, NFCNDEFReaderSessionDelegate {
    var continuation: AsyncStream<NFCNDEFReaderSession.Event>.Continuation? { get set }
}

private final class NFCNDEFReaderSessionDelegateHandleObjectForMessage: NSObject, NFCNDEFReaderSessionDelegateHandleObject {
    var continuation: AsyncStream<NFCNDEFReaderSession.Event>.Continuation?
    
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
    var continuation: AsyncStream<NFCNDEFReaderSession.Event>.Continuation?
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        continuation?.yield(.sessionBecomeActive)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        fatalError("This method should not be called.")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [any NFCNDEFTag]) {
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
