//
//  ICUCardData.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_FeliCa)
import TRETJapanNFCReader_FeliCa
#endif

public struct ICUCardData: FeliCaCardData {
    public var version: String = "3"
    public let type: FeliCaCardType = .fcfcampus
    public let primaryIDm: String
    public let primarySystemCode: FeliCaSystemCode
    public var contents: [FeliCaSystemCode : FeliCaSystem] = [:] {
        didSet {
            self.convert()
        }
    }

    public var id: Int?
    public var name: String?
    public var balance: Int?
    public var transactions: [ICUCardTransaction]?
    
    public init(idm: String, systemCode: FeliCaSystemCode) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
    }
    
    public init(idm: String, systemCode: FeliCaSystemCode, data: FeliCaData) {
        self.primaryIDm = idm
        self.primarySystemCode = systemCode
        self.contents = data
        self.convert()
    }

    #if os(iOS)
    @available(iOS 13.0, *)
    internal init(from fcfCampusCardData: FCFCampusCardData) {
        self.primaryIDm = fcfCampusCardData.primaryIDm
        self.primarySystemCode = fcfCampusCardData.primarySystemCode
        self.contents = fcfCampusCardData.contents
    }
    #endif

    public mutating func convert() {
        for (systemCode, system) in self.contents {
            switch systemCode {
            case self.primarySystemCode:
                let services = system.services
                for (serviceCode, blockData) in services {
                    let blockData = blockData.blockData
                    switch ICUCardItemType(serviceCode) {
                    case .identity:
                        self.convertToIdentity(blockData)
                    case .transactions:
                        self.convertToTransactions(blockData)
                    case .none:
                        break
                    }
                }
            default:
                break
            }
        }
    }

    private mutating func convertToIdentity(_ blockData: [Data]) {
        self.id = nil
        self.name = nil
        if blockData.count < 2 {
            return
        }
        
        // get student ID
        self.id = blockData[0][2...7].reduce(0) { (stack, digit) in
            return stack * 10 + Int(digit & 0x0F)
        }
        
        // get student name
        self.name = String(bytes: blockData[1].filter({ 0x41...0x5A ~= $0 || $0 == 0x2C}), encoding: .utf8)
    }

    private mutating func convertToTransactions(_ blockData: [Data]) {
        self.transactions = nil
        if blockData.count < 1 {
            return
        }
        self.transactions = blockData.map { toTransaction(data:$0) }
        self.balance = self.transactions?.first?.balance
    }

    private mutating func toTransaction(data: Data) -> ICUCardTransaction {
        // TODO: Currently, analysis is not perfect. So only hour and min can be obtained from data.
        // In the future, if it becomes possible to get date info, add the code here.
        enum t: Int {
            case min = 60
            case hour = 3600
            case day = 86400
        }
        let base: Date = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))!

        let hour: Int = Int(data[3])
        let min: Int = Int(data[4])
        let sec: Int = Int(data[5])
        let daysSince2000: Int = Int(UInt(data[1]) << 8 + UInt(data[0]))
        let date: Date = Date(timeInterval: TimeInterval(daysSince2000 * t.day.rawValue + hour * t.hour.rawValue + min * t.min.rawValue + sec), since: base)

        return ICUCardTransaction(
            date: date,
            type: (data[4] == 0x11) ? .credit : .purchase,
            // difference and balance are signed but it never becomes negagtive. IMO this should be fixed.
            difference: Int(UInt(data[9]) << 8 + UInt(data[8])),
            balance: Int(UInt(data[12]) << 8 + UInt(data[11]))
        )
    }
    
    
    @available(*, unavailable, renamed: "primaryIDm")
    public var idm: String { return "" }
    @available(*, unavailable, renamed: "primarySystemCode")
    public var systemCode: FeliCaSystemCode { return 0xFFFF }
    @available(*, unavailable)
    public var data: [FeliCaServiceCode : [Data]] { return [:] }
}

public struct ICUCardTransaction: FeliCaCardTransaction {
    public var date: Date
    public var type: FeliCaCardTransactionType
    public var difference: Int
    public var balance: Int

    public init(date: Date, type: FeliCaCardTransactionType, difference: Int, balance: Int) {
        self.date = date
        self.type = type
        self.difference = difference
        self.balance = balance
    }
}
