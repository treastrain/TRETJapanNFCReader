//
//  NanacoReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
public typealias NanacoCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class NanacoReader: FeliCaReader {
    
    private var nanacoCardItemTypes: [NanacoCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// NanacoCardReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// nanacoカードからデータを読み取る
    /// - Parameter itemTypes: nanacoカードから読み取りたいデータ
    public func get(itemTypes: [NanacoCardItemType]) {
        self.nanacoCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [NanacoCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.nanacoCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        var nanacoCard = NanacoCard(tag: feliCaTag, data: NanacoCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRNanacoReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.nanacoCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: nanacoCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            var systems = nanacoCard.data.contents[systemCode] ?? []
            systems.append(FeliCaSystem(systemCode: systemCode, idm: idm, services: services))
            nanacoCard.data.contents[systemCode] = systems
            completion(nanacoCard)
        }
    }
}
