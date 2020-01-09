//
//  NanacoReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/08/27.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

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
    @available(*, unavailable)
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// nanacoカードからデータを読み取る
    /// - Parameter itemTypes: nanacoカードから読み取りたいデータ
    public func get(itemTypes: [NanacoCardItemType]) {
        self.nanacoCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [NanacoCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.nanacoCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var nanacoCard = NanacoCard(tag: feliCaTag, data: NanacoCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRNanacoReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.nanacoCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: nanacoCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            nanacoCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(nanacoCard)
        }
        */
    }
}

#endif
