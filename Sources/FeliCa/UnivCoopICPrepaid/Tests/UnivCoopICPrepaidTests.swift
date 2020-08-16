//
//  UnivCoopICPrepaidTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/16.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_UnivCoopICPrepaid

final class UnivCoopICPrepaidTests: XCTestCase {
    func testUnivCoopICPrepaidCardDataInit() {
        let systemCode = FeliCaSystemCode.common
        let idm = "112e457707ce323a"
        let pmm = "033242828247aaff"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                UnivCoopICPrepaidCardItemType.balance.parameter.serviceCode : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x23, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x77])
                ]),
                UnivCoopICPrepaidCardItemType.univCoopInfo.parameter.serviceCode : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x11, 0x75, 0x19, 0x00, 0x02, 0x72, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x19, 0x04, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x01, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                    Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]),
                ]),
                UnivCoopICPrepaidCardItemType.transactions.parameter.serviceCode : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x20, 0x20, 0x08, 0x14, 0x12, 0x35, 0x27, 0x05, 0x00, 0x05, 0x63, 0x00, 0x08, 0x03, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x14, 0x12, 0x35, 0x25, 0x01, 0x00, 0x10, 0x00, 0x00, 0x13, 0x66, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x13, 0x12, 0x31, 0x19, 0x05, 0x00, 0x06, 0x85, 0x00, 0x03, 0x66, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x13, 0x12, 0x31, 0x00, 0x01, 0x00, 0x10, 0x00, 0x00, 0x10, 0x51, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x12, 0x14, 0x15, 0x11, 0x05, 0x00, 0x01, 0x30, 0x00, 0x00, 0x51, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x11, 0x12, 0x48, 0x57, 0x05, 0x00, 0x06, 0x34, 0x00, 0x01, 0x81, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x07, 0x12, 0x31, 0x09, 0x05, 0x00, 0x04, 0x46, 0x00, 0x08, 0x15, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x08, 0x07, 0x12, 0x31, 0x08, 0x01, 0x00, 0x10, 0x00, 0x00, 0x12, 0x61, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x07, 0x31, 0x18, 0x18, 0x51, 0x05, 0x00, 0x01, 0x20, 0x00, 0x02, 0x61, 0x00, 0x00]),
                    Data([0x20, 0x20, 0x07, 0x31, 0x13, 0x02, 0x36, 0x05, 0x00, 0x05, 0x34, 0x00, 0x03, 0x81, 0x00, 0x00]),
                ])
            ])]
        let cardData = UnivCoopICPrepaidCardData(idm: idm, systemCode: systemCode, data: data)
        let transactions = [
            UnivCoopICPrepaidCardTransaction(date: "2020-08-14 03:35:27 +0000".date, type: .purchase, difference: 563, balance: 803),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-14 03:35:25 +0000".date, type: .credit, difference: 1000, balance: 1366),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-13 03:31:19 +0000".date, type: .purchase, difference: 685, balance: 366),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-13 03:31:00 +0000".date, type: .credit, difference: 1000, balance: 1051),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-12 05:15:11 +0000".date, type: .purchase, difference: 130, balance: 51),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-11 03:48:57 +0000".date, type: .purchase, difference: 634, balance: 181),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-07 03:31:09 +0000".date, type: .purchase, difference: 446, balance: 815),
            UnivCoopICPrepaidCardTransaction(date: "2020-08-07 03:31:08 +0000".date, type: .credit, difference: 1000, balance: 1261),
            UnivCoopICPrepaidCardTransaction(date: "2020-07-31 09:18:51 +0000".date, type: .purchase, difference: 120, balance: 261),
            UnivCoopICPrepaidCardTransaction(date: "2020-07-31 04:02:36 +0000".date, type: .purchase, difference: 534, balance: 381)
        ]
        
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.univCoopICPrepaid)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.balance, 803)
        XCTAssertEqual(cardData.membershipNumber, "117519000272")
        XCTAssertEqual(cardData.mealCardUser, false)
        XCTAssertEqual(cardData.mealCardLastUseDate, "2019-04-04 15:00:00 +0000".date)
        XCTAssertEqual(cardData.mealCardLastUsageAmount, 0)
        XCTAssertEqual(cardData.points, 28.7)
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
