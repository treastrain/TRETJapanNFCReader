//
//  NFCNDEFTagReaderProtocol.swift
//  NDEFTag
//
//  Created by treastrain on 2022/09/24.
//

public protocol NFCNDEFTagReaderProtocol: NFCReaderAfterDetectProtocol {
    #if canImport(CoreNFC)
    func connect(to tag: any NFCNDEFTag) async throws
    #endif
}

#if canImport(CoreNFC)
extension NDEFTag.Reader: NFCNDEFTagReaderProtocol {}
#endif
