//
//  OctopusReader.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/09/20.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

@available(iOS 13.0, *)
public typealias OctopusCardTag = NFCFeliCaTag

@available(iOS 13.0, *)
public class OctopusReader: FeliCaReader {
    
    private var octopusCardItemTypes: [OctopusCardItemType] = []
    
    private init() {
        fatalError()
    }
    
    /// Initializes OctopusReader.
    /// - Parameter feliCaReader: FeliCaReader
    public init(feliCaReader: FeliCaReader) {
        super.init(delegate: feliCaReader.delegate!)
    }
    
    /// Initializes OctopusReader.
    /// - Parameter delegate: FeliCaReaderSessionDelegate
    public override init(delegate: FeliCaReaderSessionDelegate) {
        super.init(delegate: delegate)
    }
    
    /// Initializes OctopusReader.
    /// - Parameter viewController: FeliCaReaderSessionDelegate を適用した UIViewController
    public override init(viewController: FeliCaReaderViewController) {
        super.init(viewController: viewController)
    }
    
    /// Get read data from Octopus card
    /// - Parameter itemTypes: Types of data items you want to read from Octopus card
    public func get(itemTypes: [OctopusCardItemType]) {
        self.octopusCardItemTypes = itemTypes
        self.beginScanning()
    }
    
    public func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, itemTypes: [OctopusCardItemType], completion: @escaping (FeliCaCard) -> Void) {
        self.octopusCardItemTypes = itemTypes
        self.getItems(session, feliCaCard) { (feliCaCard) in
            completion(feliCaCard)
        }
    }
    
    public override func getItems(_ session: NFCTagReaderSession, _ feliCaCard: FeliCaCard, completion: @escaping (FeliCaCard) -> Void) {
        var octopusCard = feliCaCard as! OctopusCard
        DispatchQueue(label: "TRETJPNROctopusReader", qos: .default).async {
            var data: [FeliCaServiceCode : [Data]] = [:]
            for itemType in self.octopusCardItemTypes {
                data[itemType.serviceCode] = self.readWithoutEncryption(session: session, tag: octopusCard.tag, serviceCode: itemType.serviceCode, blocks: itemType.blocks)
            }
            octopusCard.data.data = data
            completion(octopusCard)
        }
    }
}
