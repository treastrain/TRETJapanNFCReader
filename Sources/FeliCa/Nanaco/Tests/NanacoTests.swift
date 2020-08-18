//
//  NanacoTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/18.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_Nanaco

final class NanacoTests: XCTestCase {
    func testNanacoCardDataInit() {
        let systemCode: FeliCaSystemCode = 0xFE00
        let idm = ""
        let pmm = ""
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                0x5597 : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x6B, 0x01, 0x00, 0x00, 0x41, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0B, 0x00])
                ]),
                0x558B : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x76, 0x00, 0x12, 0x34, 0x56, 0x78, 0x90, 0x12, 0x01, 0x1E, 0x96, 0x01, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x01, 0x27, 0x1B, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                ]),
                0x560B : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x01, 0x00, 0x28, 0x67, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x53, 0x2A, 0x7F, 0x00, 0x00, 0x00, 0x28, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                ]),
                0x564F : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x47, 0x00, 0x00, 0x04, 0x41, 0x00, 0x00, 0x01, 0x6B, 0x02, 0x86, 0x71, 0x18, 0x00, 0x13, 0x00]),
                    Data([0x6F, 0x00, 0x00, 0x03, 0xE8, 0x00, 0x00, 0x05, 0xAC, 0x02, 0x86, 0x71, 0x17, 0x00, 0x12, 0x00]),
                    Data([0x47, 0x00, 0x00, 0x04, 0xBD, 0x00, 0x00, 0x01, 0xC4, 0x02, 0x86, 0x25, 0x42, 0x00, 0x11, 0x00]),
                    Data([0x6F, 0x00, 0x00, 0x03, 0xE8, 0x00, 0x00, 0x06, 0x81, 0x02, 0x86, 0x25, 0x42, 0x00, 0x10, 0x00]),
                    Data([0x47, 0x00, 0x00, 0x01, 0x91, 0x00, 0x00, 0x02, 0x99, 0x02, 0x84, 0xA4, 0x36, 0x00, 0x0F, 0x00]),
                ])
            ])
        ]
        let cardData = NanacoCardData(idm: idm, systemCode: systemCode, data: data)
        let transactions = [
            NanacoCardTransaction(date: "2020-03-06 19:24:00 +0000".date, type: .purchase, otherType: nil, difference: 1089, balance: 363),
            NanacoCardTransaction(date: "2020-03-06 19:23:00 +0000".date, type: .credit, otherType: nil, difference: 1000, balance: 1452),
            NanacoCardTransaction(date: "2020-03-02 12:02:00 +0000".date, type: .purchase, otherType: nil, difference: 1213, balance: 452),
            NanacoCardTransaction(date: "2020-03-02 12:02:00 +0000".date, type: .credit, otherType: nil, difference: 1000, balance: 1665),
            NanacoCardTransaction(date: "2020-02-10 07:54:00 +0000".date, type: .purchase, otherType: nil, difference: 401, balance: 665)
        ]
        
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.nanaco)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.balance, 363)
        XCTAssertEqual(cardData.nanacoNumber, "7600-1234-5678-9012")
        XCTAssertEqual(cardData.points, 83)
        XCTAssertNotNil(cardData.transactions)
        for (cardDataTransaction, dummyTransaction) in zip(cardData.transactions!, transactions) {
            XCTAssertEqual(cardDataTransaction.date, dummyTransaction.date)
            XCTAssertEqual(cardDataTransaction.type, dummyTransaction.type)
            XCTAssertEqual(cardDataTransaction.otherType, dummyTransaction.otherType)
            XCTAssertEqual(cardDataTransaction.difference, dummyTransaction.difference)
            XCTAssertEqual(cardDataTransaction.balance, dummyTransaction.balance)
        }
    }
}

extension String {
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)!
    }
}
