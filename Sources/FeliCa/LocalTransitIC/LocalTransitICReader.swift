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
    
    private var localTransitICCardItemTypes: [LocalTransitICCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// LocalTransitICReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// LocalTransitICReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// LocalTransitICReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// 地方交通系ICカードからデータを読み取る
    /// - Parameter itemTypes: 地方交通系ICカードから読み取りたいデータのタイプ
    public func get(itemTypes: [LocalTransitICCardItemType]) {
        self.localTransitICCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        if let localTransitICSystem = feliCaData[.ryuto] {
            let localTransitICCardData = LocalTransitICCardData(idm: localTransitICSystem.idm, systemCode: localTransitICSystem.systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: localTransitICCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [LocalTransitICCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.ryutoCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var ryutoCard = RyutoCard(tag: feliCaTag, data: RyutoCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRRyutoReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.ryutoCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: ryutoCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            ryutoCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(ryutoCard)
        }
        */
    }
}

@available(iOS 13.0, *)
@available(*, unavailable, renamed: "LocalTransitICCardTag")
public typealias RyutoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
@available(*, unavailable, renamed: "LocalTransitICReader")
public class RyutoReader: FeliCaReader {}

#endif
