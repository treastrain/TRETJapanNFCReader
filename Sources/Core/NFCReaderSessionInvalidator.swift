//
//  NFCReaderSessionInvalidator.swift
//  Core
//
//  Created by treastrain on 2022/09/24.
//

#if canImport(CoreNFC)
package final class NFCReaderSessionInvalidator<Base: NFCReaderSessionProtocol>: @unchecked Sendable {
    private weak var readerSession: Base?
    
    package init(_ readerSession: Base) {
        self.readerSession = readerSession
    }
    
    package func invalidate(errorMessage: String) {
        readerSession?.invalidate(errorMessage: errorMessage)
    }
}
#endif
