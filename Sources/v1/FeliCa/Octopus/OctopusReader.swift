//
//  OctopusReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

#if os(iOS)
import CoreNFC
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

@available(iOS 13.0, *)
public typealias OctopusCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class OctopusReader: FeliCaReader {
    
    /// A Boolean value indicating whether to support reading older Octopus cards (issued before 2004).
    private var isSupportedPre2004 = false
    private var octopusCardItemTypes: [OctopusCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// Initializes OctopusReader.
    /// - Parameter feliCaReader: FeliCaReader
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// Initializes OctopusReader.
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    /// - Parameter isSupportedPre2004: A Boolean value indicating whether to support reading older Octopus cards (issued before 2004).
    public init(delegate: FeliCaReaderSessionDelegate, isSupportedPre2004: Bool = false) {
        self.isSupportedPre2004 = isSupportedPre2004
        super.init(delegate: delegate)
    }
    
    /// Initializes OctopusReader.
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    @available(*, unavailable, renamed: "init(delegate:)")
    public init(viewController: FeliCaReaderViewController) {
        super.init(delegate: viewController)
    }
    
    /// Get read data from Octopus card
    /// - Parameter itemTypes: Types of data items you want to read from Octopus card
    public func get(itemTypes: [OctopusCardItemType]) {
        self.octopusCardItemTypes = itemTypes
        let parameters = itemTypes.map { $0.parameter }
        self.readWithoutEncryption(parameters: parameters)
    }
    
    public override func feliCaTagReaderSessionReadWithoutEncryption(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag) {
        if !self.isSupportedPre2004 {
            super.feliCaTagReaderSessionReadWithoutEncryption(session, feliCaTag: feliCaTag)
            return
        }
        
        var feliCaData: FeliCaData = [:]
        let pollingErrors: [FeliCaSystemCode : Error?] = [:]
        var readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]] = [:]
        
        let targetSystemCode = FeliCaSystemCode.octopus
        let currentPMm = Data()
        
        var services: [FeliCaServiceCode : FeliCaBlockData] = [:]
        let serviceCodeData = self.serviceCodes[targetSystemCode]!
        for (serviceCode, numberOfBlock) in serviceCodeData {
            let blockList = (0..<numberOfBlock).map { (block) -> Data in
                Data([0x80, UInt8(block)])
            }
            let (status1, status2, blockData, error) = feliCaTag.readWithoutEncryption36(serviceCode: serviceCode.data, blockList: blockList)
            services[serviceCode] = FeliCaBlockData(status1: status1, status2: status2, blockData: blockData)
            if let error = error {
                if readErrors[targetSystemCode] == nil {
                    readErrors[targetSystemCode] = [serviceCode : error]
                } else {
                    readErrors[targetSystemCode]![serviceCode] = error
                }
            }
        }
        
        feliCaData[targetSystemCode] = FeliCaSystem(systemCode: targetSystemCode, idm: feliCaTag.currentIDm.hexString, pmm: currentPMm.hexString, services: services)
        
        session.alertMessage = Localized.nfcTagReaderSessionDoneMessage.string()
        session.invalidate()
        self.feliCaReaderSession(
            didRead: feliCaData,
            pollingErrors: pollingErrors.isEmpty ? nil : pollingErrors,
            readErrors: readErrors.isEmpty ? nil : readErrors
        )
    }
    
    public override func feliCaReaderSession(didRead feliCaData: FeliCaData, pollingErrors: [FeliCaSystemCode : Error?]?, readErrors: [FeliCaSystemCode : [FeliCaServiceCode : Error]]?) {
        if let octopusSystem = feliCaData[.octopus] {
            let rakutenEdyCardData = OctopusCardData(idm: octopusSystem.idm, systemCode: octopusSystem.systemCode, data: feliCaData)
            self.delegate?.feliCaReaderSession(didRead: rakutenEdyCardData, pollingErrors: pollingErrors, readErrors: readErrors)
        } else {
            self.delegate?.feliCaReaderSession(didInvalidateWithError: pollingErrors, readErrors: readErrors)
        }
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, itemTypes: [OctopusCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        /*
        self.octopusCardItemTypes = itemTypes
        self.getItems(session, feliCaTag: feliCaTag, idm: idm, systemCode: systemCode) { (feliCaCard) in
            completion(feliCaCard)
        }
        */
    }
    
    @available(*, unavailable)
    public func getItems(_ session: NFCTagReaderSession, feliCaTag: NFCFeliCaTag, idm: String, systemCode: FeliCaSystemCode, completion: @escaping (FeliCaCard) -> Void) {
        /*
        var octopusCard = OctopusCard(tag: feliCaTag, data: OctopusCardData(idm: idm, systemCode: systemCode))
        DispatchQueue(label: "TRETJPNROctopusReader", qos: .default).async {
            var services: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.octopusCardItemTypes {
                services[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: octopusCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            octopusCard.data.contents[systemCode] = FeliCaSystem(systemCode: systemCode, idm: idm, services: services)
            completion(octopusCard)
        }
        */
    }
}

#endif
