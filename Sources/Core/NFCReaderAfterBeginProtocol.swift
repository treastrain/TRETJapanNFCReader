//
//  NFCReaderAfterBeginProtocol.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCReaderAfterBeginProtocol: Actor {
    #if canImport(CoreNFC)
    var isReady: Bool { get }
    var alertMessage: String { get set }
    func set(alertMessage: String)
    func invalidate()
    func invalidate(errorMessage: String)
    #endif
}
