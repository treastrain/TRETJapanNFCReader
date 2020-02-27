//
//  WaonReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/25.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias WaonCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class WaonReader: FeliCaReader {
    
    private var waonCardItemTypes: [WaonCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// WaonReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// WaonReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// WaonReader を初期化する。
    /// - Parameter viewController: FeliCaReaderViewController
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// WAONカードからデータを読み取る
    /// - Parameter itemTypes: WAONカードから読み取りたいデータ
    public func get(itemTypes: [WaonCardItemType]) {
        self.waonCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        if let commonSystem = feliCaData[.common] {
            let waonCardData = WaonCardData(idm: commonSystem.idm, systemCode: commonSystem.systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: waonCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [WaonCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.waonCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var waonCard = WaonCard(tag: feliCaTag, data: WaonCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRWaonReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.waonCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: waonCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            waonCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(waonCard)
        }
        */
    }
}

#endif
