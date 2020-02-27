//
//  RakutenEdyReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/22.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias RakutenEdyCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class RakutenEdyReader: FeliCaReader {

    private var rakutenEdyCardItemTypes: [RakutenEdyCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// RakutenEdyReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// 楽天Edyカードからデータを読み取る
    /// - Parameter itemTypes: 楽天Edyカードから読み取りたいデータのタイプ
    public func get(itemTypes: [RakutenEdyCardItemType]) {
        self.rakutenEdyCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        if let commonSystem = feliCaData[.common] {
            let rakutenEdyCardData = RakutenEdyCardData(idm: commonSystem.idm, systemCode: commonSystem.systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: rakutenEdyCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [RakutenEdyCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.rakutenEdyCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var rakutenEdyCard = RakutenEdyCard(tag: feliCaTag, data: RakutenEdyCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRRakutenEdyReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.rakutenEdyCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: rakutenEdyCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            rakutenEdyCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(rakutenEdyCard)
        }
        */
    }
}

#endif
