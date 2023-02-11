//
//  NFCReaderSessionAfterBeginProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCReaderSessionAfterBeginProtocol: NSObjectProtocol, Sendable {
    #if canImport(CoreNFC)
    var isReady: Bool { get }
    var alertMessage: String { get set }
    func invalidate()
    func invalidate(errorMessage: String)
    #endif
}

extension NFCReaderSessionAfterBeginProtocol {
    @available(*, unavailable, message: "Use `DetectResult.restartPolling`")
    public func restartPolling() {}
}
