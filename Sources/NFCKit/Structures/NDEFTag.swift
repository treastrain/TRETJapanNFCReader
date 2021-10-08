//
//  NDEFTag.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/05/18.
//

import Foundation
#if os(iOS)
import CoreNFC
#endif

public struct NDEFTag {
    /// A Boolean value that determines whether the NDEF tag is available in the current reader session.
    public var isAvailable: Bool {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        if #available(iOS 13.0, *) {
            return self.core.isAvailable
        } else {
            return false
        }
        #else
        return false
        #endif
    }
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    private var _core: Any?
    @available(iOS 13.0, *)
    internal var core: CoreNFC.NFCNDEFTag {
        get {
            return self._core as! CoreNFC.NFCNDEFTag
        }
        set {
            self._core = newValue
        }
    }
    #endif
    
    #if os(iOS) && !targetEnvironment(macCatalyst)
    @available(iOS 13.0, *)
    internal init(from core: CoreNFC.NFCNDEFTag) {
        self.core = core
    }
    #endif
}

#if os(iOS) && !targetEnvironment(macCatalyst)
extension NDEFTag: NDEFTagProtocol {
    @available(iOS 13.0, *)
    public func readNDEF(resultHandler: @escaping (Result<NDEFMessage?, Error>) -> Void) {
        self.core.readNDEF { message, error in
            if let error = error {
                resultHandler(.failure(error))
            } else {
                guard let message = message else {
                    resultHandler(.success(nil))
                    return
                }
                resultHandler(.success(NDEFMessage(from: message)))
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func writeNDEF(_ ndefMessage: NDEFMessage, resultHandler: @escaping (Result<Void, Error>) -> Void) {
        self.core.writeNDEF(NFCNDEFMessage(from: ndefMessage)) { error in
            if let error = error {
                resultHandler(.failure(error))
            } else {
                resultHandler(.success(()))
            }
        }
    }
    
    @available(iOS 13.0, *)
    public func writeLock(resultHandler: @escaping (Result<Void, Error>) -> Void) {
        self.core.writeLock { error in
            if let error = error {
                resultHandler(.failure(error))
            } else {
                resultHandler(.success(()))
            }
        }
    }
}
#endif
