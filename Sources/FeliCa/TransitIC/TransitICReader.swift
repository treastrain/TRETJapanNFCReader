//
//  TransitICReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/04.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias TransitICCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class TransitICReader: FeliCaReader {
    
    private var systemCode: FeliCaSystemCode = .cjrc
    private var transitICCardItemTypes: [TransitICCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter feliCaReader: FeliCaReader
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    /// - Parameter systemCode: FeliCa システムコード
    public init(delegate: FeliCaReaderSessionDelegate, systemCode: FeliCaSystemCode = .cjrc) {
        self.systemCode = systemCode
        super.init(delegate: delegate)
    }
    
    /// TransitICReader を初期化する。
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// 交通系ICカードからデータを読み取る
    /// - Parameter items: 交通系ICカードから読み取りたいデータ
    public func get(itemTypes: [TransitICCardItemType]) {
        var itemTypes = itemTypes
        if self.systemCode != .sapica {
            itemTypes = itemTypes.filter { $0 != .sapicaPoints }
        }
        self.transitICCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter(systemCode: self.systemCode) }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        
        if let firstData = feliCaData.first {
            print(firstData)
            let systemCode = firstData.key
            let idm = firstData.value.idm
            let transitICCardData = TransitICCardData(idm: idm, systemCode: systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: transitICCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [TransitICCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.transitICCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var transitICCard = TransitICCard(tag: feliCaTag, data: TransitICCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNRTransitICReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            
            if transitICCard.data.primarySystemCode != FeliCaSystemCode.sapica {
                self.transitICCardItemTypes = self.transitICCardItemTypes.filter { $0 != .sapicaPoints }
            }
            
            for itemType in self.transitICCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: transitICCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            
            transitICCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(transitICCard)
        }
        */
    }
}

#endif
