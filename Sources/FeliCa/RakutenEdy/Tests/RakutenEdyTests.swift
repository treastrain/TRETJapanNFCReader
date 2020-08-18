//
//  RakutenEdyTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/17.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_RakutenEdy

final class RakutenEdyTests: XCTestCase {
    func testRakutenEdyCardDataInit() {
        let systemCode: FeliCaSystemCode = 0xFE00
        let idm = "1114c425a40f8d26"
        let pmm = "0f0d23042f7783ff"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                0x1317 : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x23, 0x00, 0x00, 0x00, 0x96, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00])
                ]),
                0x110B : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x00, 0x02, 0x19, 0x01, 0x23, 0x45, 0x67, 0x89, 0x01, 0x23, 0x28, 0x90, 0x00, 0x00, 0x00, 0x11]),
                    Data([0x00, 0x00, 0x61, 0xA8, 0x00, 0x00, 0xC3, 0x50, 0x00, 0x00, 0xC3, 0x50, 0x00, 0x00, 0x00, 0x00]),
                ]),
                0x170F : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x20, 0x00, 0x00, 0x04, 0x38, 0x62, 0xD5, 0xB3, 0x00, 0x00, 0x00, 0x96, 0x00, 0x00, 0x00, 0x23]),
                    Data([0x20, 0x00, 0x00, 0x03, 0x38, 0x33, 0x18, 0x6C, 0x00, 0x00, 0x02, 0x62, 0x00, 0x00, 0x00, 0xB9]),
                    Data([0x20, 0x00, 0x00, 0x02, 0x38, 0x0B, 0x20, 0x30, 0x00, 0x00, 0x00, 0xCD, 0x00, 0x00, 0x03, 0x1B]),
                    Data([0x02, 0x00, 0x00, 0x01, 0x38, 0x0B, 0x20, 0x22, 0x00, 0x00, 0x03, 0xE8, 0x00, 0x00, 0x03, 0xE8]),
                    Data([0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                ])
            ])
        ]
        let cardData = RakutenEdyCardData(idm: idm, systemCode: systemCode, data: data)
        let transactions = [
            RakutenEdyCardTransaction(date: "2019-10-05 15:11:47 +0900".date, type: .purchase, difference: 150, balance: 35),
            RakutenEdyCardTransaction(date: "2019-09-11 19:56:28 +0900".date, type: .purchase, difference: 610, balance: 185),
            RakutenEdyCardTransaction(date: "2019-08-22 20:29:36 +0900".date, type: .purchase, difference: 205, balance: 795),
            RakutenEdyCardTransaction(date: "2019-08-22 20:29:22 +0900".date, type: .credit, difference: 1000, balance: 1000)
        ]
        
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.rakutenEdy)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.balance, 35)
        XCTAssertEqual(cardData.edyNumber, "1901 2345 6789 0123")
        XCTAssertNotNil(cardData.transactions)
        for (cardDataTransaction, dummyTransaction) in zip(cardData.transactions!, transactions) {
            XCTAssertEqual(cardDataTransaction.date, dummyTransaction.date)
            XCTAssertEqual(cardDataTransaction.type, dummyTransaction.type)
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
