//
//  NFCReaderAfterDetectProtocol.swift
//  Core
//
//  Created by treastrain on 2023/05/04.
//

public protocol NFCReaderAfterDetectProtocol: NFCReaderAfterBeginProtocol {
    #if canImport(CoreNFC)
    #endif
}
