//
//  FCFCampusTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/22.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_FCFCampus

final class FCFCampusTests: XCTestCase {
    func testICUCardDataInit() {
        let systemCode: FeliCaSystemCode = 0x8760
        let idm = "0123456789012345"
        let pmm = "0123456789012345"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                0x1A8B : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x30, 0x31, 0x32, 0x32, 0x30, 0x30, 0x30, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x31, 0x30]),
                    Data([0x54, 0x45, 0x53, 0x55, 0x54, 0x4F, 0x2C, 0x54, 0x41, 0x52, 0x4F, 0x00, 0x00, 0x00, 0x00, 0x00]),
                ]),
                0x120F : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0xC0, 0x1C, 0x13, 0x39, 0x21, 0x0C, 0x60, 0x12, 0x2C, 0x01, 0x00, 0x80, 0x02, 0x00, 0xB3, 0x00]),
                    Data([0xBF, 0x1C, 0x13, 0x10, 0x21, 0x0C, 0x7C, 0x11, 0x2C, 0x01, 0x00, 0xAC, 0x03, 0x00, 0xB2, 0x00]),
                    Data([0xBF, 0x1C, 0x13, 0x10, 0x11, 0x5D, 0x1E, 0x00, 0xE8, 0x03, 0x00, 0xD8, 0x04, 0x00, 0xFF, 0xFF]),
                    Data([0xBA, 0x1C, 0x15, 0x46, 0x21, 0x0C, 0x51, 0x0F, 0x2C, 0x01, 0x00, 0xF0, 0x00, 0x00, 0xB1, 0x00]),
                    Data([0xB5, 0x1C, 0x13, 0x31, 0x21, 0x0D, 0x1C, 0x1D, 0x90, 0x01, 0x00, 0x1C, 0x02, 0x00, 0xB0, 0x00]),
                    Data([0xB3, 0x1C, 0x16, 0x17, 0x21, 0x0D, 0x1C, 0x1C, 0x90, 0x01, 0x00, 0xAC, 0x03, 0x00, 0xAF, 0x00]),
                    Data([0xB3, 0x1C, 0x16, 0x17, 0x11, 0x5D, 0x57, 0x00, 0xE8, 0x03, 0x00, 0x3C, 0x05, 0x00, 0xFF, 0xFF]),
                    Data([0x76, 0x1C, 0x13, 0x31, 0x21, 0x0D, 0x0F, 0x08, 0xA4, 0x01, 0x00, 0x54, 0x01, 0x00, 0xAE, 0x00]),
                    Data([0x73, 0x1C, 0x13, 0x30, 0x21, 0x0C, 0xC3, 0x0E, 0x2C, 0x01, 0x00, 0xF8, 0x02, 0x00, 0xAD, 0x00]),
                    Data([0x73, 0x1C, 0x13, 0x30, 0x11, 0x5C, 0x52, 0x00, 0xE8, 0x03, 0x00, 0x24, 0x04, 0x00, 0xFF, 0xFF]),
                ])
            ])
        ]
        let cardData = ICUCardData(idm: idm, systemCode: systemCode, data: data)
        let transactions = [
            ICUCardTransaction(date: "2020-02-27 00:33:12 +0000".date, type: .purchase, difference: 300, balance: 640),
            ICUCardTransaction(date: "2020-02-24 07:33:12 +0000".date, type: .purchase, difference: 300, balance: 940),
            ICUCardTransaction(date: "2020-02-24 07:18:33 +0000".date, type: .credit, difference: 1000, balance: 1240),
            ICUCardTransaction(date: "2020-02-21 13:33:12 +0000".date, type: .purchase, difference: 300, balance: 240),
            ICUCardTransaction(date: "2020-02-15 16:33:13 +0000".date, type: .purchase, difference: 400, balance: 540),
            ICUCardTransaction(date: "2020-02-12 14:33:13 +0000".date, type: .purchase, difference: 400, balance: 940),
            ICUCardTransaction(date: "2020-02-12 14:18:33 +0000".date, type: .credit, difference: 1000, balance: 1340),
            ICUCardTransaction(date: "2019-12-14 16:33:13 +0000".date, type: .purchase, difference: 420, balance: 340),
            ICUCardTransaction(date: "2019-12-11 15:33:12 +0000".date, type: .purchase, difference: 300, balance: 760),
            ICUCardTransaction(date: "2019-12-11 15:18:32 +0000".date, type: .credit, difference: 1000, balance: 1060)
        ]
        
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.fcfcampus)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.id, 220000)
        XCTAssertEqual(cardData.name, "TESUTO,TARO")
        XCTAssertEqual(cardData.balance, 640)
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
