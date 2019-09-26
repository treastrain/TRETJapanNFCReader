//
//  ICUCardData.swift
//  TRETJapanNFCReader
//
//  Created by Qs-F on 2019/09/26.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public struct ICUCardData: FeliCaCardData {
    public let type: FeliCaCardType = .fcfcampus
    public let idm: String
    public let systemCode: FeliCaSystemCode
    public var data: [FeliCaServiceCode : [Data]] = [:] {
        didSet {
            self.convert()
        }
    }

    public var id: Int?
    public var name: String?
    public var balance: Int?
    public var transactions: [ICUCardTransaction]?

    @available(iOS 13.0, *)
    internal init(from fcfCampusCardData: FCFCampusCardData) {
        self.idm = fcfCampusCardData.idm
        self.systemCode = fcfCampusCardData.systemCode
        self.data = fcfCampusCardData.data
    }

    public mutating func convert() {
        for (key, value) in self.data {
            let blockData = value
            switch ICUItemType(key) {
            case .identity:
                self.convertToIdentity(blockData)
            case .transactions:
                self.convertToTransactions(blockData)
            case .none:
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
    }

    private mutating func toTransaction(data: Data) -> ICUCardTransaction {
        // TODO: Currently, analysis is not perfect. So only hour and min can be obtained from data.
        // In the future, if it becomes possible to get date info, add the code here.
        let hour: Int = Int(data[3])
        let min: Int = Int(data[4])
        let date = Calendar.current.date(from: DateComponents(hour: hour, minute: min))!

        return ICUCardTransaction(
            date: date,
            type: (data[15] == 0xFF) ? .credit : .purchase,

            // difference and balance are signed but it never becomes negagtive. IMO this should be fixed.
            difference: Int(UInt(data[9]) << 2 + UInt(data[8])),
            balance: Int(UInt(data[12]) << 2 + UInt(data[11]))
        )
    }
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
