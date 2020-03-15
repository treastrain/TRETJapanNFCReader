//
//  LocalTransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/11/21.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias LocalTransitICCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class LocalTransitICReader: FeliCaReader {
    
    private var systemCode: FeliCaSystemCode
    private var localTransitICCardItemTypes: [LocalTransitICCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// LocalTransitICReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public init(delegate: FeliCaReaderSessionDelegate, systemCode: FeliCaSystemCode) {
        self.systemCode = systemCode
        super.init(delegate: delegate)
    }
    
    /// 地方交通系ICカードからデータを読み取る
    /// - Parameter itemTypes: 地方交通系ICカードから読み取りたいデータのタイプ
    public func get(itemTypes: [LocalTransitICCardItemType]) {
        self.localTransitICCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter(systemCode: self.systemCode) }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
        if let localTransitICSystem = feliCaData[self.systemCode] {
            let localTransitICCardData = LocalTransitICCardData(idm: localTransitICSystem.idm, systemCode: localTransitICSystem.systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: localTransitICCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
}

@available(iOS 13.0, *)
@available(*, unavailable, renamed: "LocalTransitICCardTag")
public typealias RyutoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
@available(*, unavailable, renamed: "LocalTransitICReader")
public class RyutoReader: FeliCaReader {}

#endif
