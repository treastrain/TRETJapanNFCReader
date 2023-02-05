//
//  NFCReaderSessionable.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
public protocol NFCReaderSessionable: NFCReaderSessionProtocol {
    associatedtype Session
    associatedtype Delegate // TODO: inherit `NSObjectProtocol`
    associatedtype AfterBeginProtocol: Sendable
    
    var delegate: AnyObject? { get }
    static var readingAvailable: Bool { get }
}
#endif

#if canImport(CoreNFC)
extension NFCNDEFReaderSession: NFCReaderSessionable, NFCReaderSessionAfterBeginProtocol, @unchecked Sendable {
    public typealias Session = NFCNDEFReaderSession
    public typealias Delegate = NFCNDEFReaderSessionDelegate
    public typealias AfterBeginProtocol = _NFCNDEFReaderSessionOpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderSessionAfterBeginProtocol`
}

extension NFCTagReaderSession: NFCReaderSessionable, NFCReaderSessionAfterBeginProtocol, @unchecked Sendable {
    public typealias Session = NFCTagReaderSession
    public typealias Delegate = NFCTagReaderSessionDelegate
    public typealias AfterBeginProtocol = _NFCTagReaderSessionOpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderSessionAfterBeginProtocol`
}

extension NFCVASReaderSession: NFCReaderSessionable, NFCReaderSessionAfterBeginProtocol, @unchecked Sendable {
    public typealias Session = NFCVASReaderSession
    public typealias Delegate = NFCVASReaderSessionDelegate
    public typealias AfterBeginProtocol = _NFCVASReaderSessionOpaqueTypeBuilder.AfterBeginProtocol // it means like `some NFCReaderSessionAfterBeginProtocol`
}
#endif

#if canImport(CoreNFC)
public protocol _NFCReaderSessionableOpaqueTypeBuilderProtocol {
    associatedtype AfterBeginProtocol: Sendable
    var afterBeginProtocol: AfterBeginProtocol { get }
}

public class _NFCNDEFReaderSessionOpaqueTypeBuilder: NSObject, _NFCReaderSessionableOpaqueTypeBuilderProtocol, NFCNDEFReaderSessionDelegate {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderSessionAfterBeginProtocol`, which will not be called from either place.
    public var afterBeginProtocol: some NFCReaderSessionAfterBeginProtocol {
        NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }
    
    public func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {}
    public func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {}
}

public class _NFCTagReaderSessionOpaqueTypeBuilder: NSObject, _NFCReaderSessionableOpaqueTypeBuilderProtocol, NFCTagReaderSessionDelegate {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderSessionAfterBeginProtocol`, which will not be called from either place.
    public var afterBeginProtocol: some NFCReaderSessionAfterBeginProtocol {
        NFCTagReaderSession(pollingOption: [], delegate: self)!
    }
    
    public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}
    public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {}
    public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {}
}

public class _NFCVASReaderSessionOpaqueTypeBuilder: NSObject, _NFCReaderSessionableOpaqueTypeBuilderProtocol, NFCVASReaderSessionDelegate {
    /// This is a dummy property to give `AfterBeginProtocol` to `some NFCReaderSessionAfterBeginProtocol`, which will not be called from either place.
    public var afterBeginProtocol: some NFCReaderSessionAfterBeginProtocol {
        NFCVASReaderSession(vasCommandConfigurations: [], delegate: self, queue: nil)
    }
    
    public func readerSession(_ session: NFCVASReaderSession, didInvalidateWithError error: Error) {}
    public func readerSession(_ session: NFCVASReaderSession, didReceive responses: [NFCVASResponse]) {}
}
#endif
