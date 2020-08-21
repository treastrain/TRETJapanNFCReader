//
//  OkicaTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/21.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_Okica

final class OkicaTests: XCTestCase {
    func testOkicaCardDataInit() {
        let systemCode: FeliCaSystemCode = 0x8FC1
        let idm = "1234567890123456"
        let pmm = "0123456789012345"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                0x028F : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x16, 0x01, 0x00, 0x02, 0x28, 0x9E, 0xDC, 0x07, 0xDC, 0x01, 0x38, 0x04, 0x00, 0x00, 0x2F, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x28, 0x92, 0xDC, 0x1F, 0xDC, 0x07, 0x1E, 0x05, 0x00, 0x00, 0x2E, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x28, 0x91, 0xDC, 0x27, 0xDC, 0x1F, 0x90, 0x06, 0x00, 0x00, 0x2D, 0x50]),
                    Data([0x08, 0x02, 0x00, 0x00, 0x28, 0x90, 0xDC, 0x27, 0x00, 0x00, 0x9E, 0x07, 0x00, 0x00, 0x2C, 0x40]),
                    Data([0x05, 0x0F, 0x00, 0x0F, 0x28, 0x8F, 0x0B, 0x02, 0x00, 0x00, 0xB6, 0x03, 0x00, 0x00, 0x2B, 0x80]),
                    Data([0x05, 0x0F, 0x00, 0x0F, 0x28, 0x8E, 0x0B, 0x02, 0x00, 0x00, 0x5E, 0x06, 0x00, 0x00, 0x2A, 0x80]),
                    Data([0x05, 0x0F, 0x00, 0x0F, 0x28, 0x8D, 0x0B, 0x02, 0x00, 0x00, 0x5E, 0x06, 0x00, 0x00, 0x29, 0x80]),
                    Data([0x05, 0x1F, 0x00, 0x00, 0x28, 0x8C, 0x0B, 0x02, 0x00, 0x00, 0x06, 0x09, 0x00, 0x00, 0x28, 0x80]),
                    Data([0x08, 0x48, 0x04, 0x00, 0x28, 0x8B, 0xDC, 0x19, 0x00, 0x00, 0xAE, 0x0B, 0x00, 0x00, 0x27, 0x40]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x28, 0x7A, 0xDC, 0x25, 0xDC, 0x27, 0x72, 0x0B, 0x00, 0x00, 0x26, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x79, 0xDC, 0x21, 0xDC, 0x23, 0x58, 0x0C, 0x00, 0x00, 0x25, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x78, 0xDC, 0x1D, 0xDC, 0x1F, 0x3E, 0x0D, 0x00, 0x00, 0x24, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x77, 0xDC, 0x19, 0xDC, 0x1B, 0x24, 0x0E, 0x00, 0x00, 0x23, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x76, 0xDC, 0x15, 0xDC, 0x17, 0x0A, 0x0F, 0x00, 0x00, 0x22, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x65, 0xDC, 0x11, 0xDC, 0x13, 0xF0, 0x0F, 0x00, 0x00, 0x21, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x64, 0xDC, 0x0D, 0xDC, 0x0F, 0xDC, 0x10, 0x00, 0x00, 0x20, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x63, 0xDC, 0x09, 0xDC, 0x0B, 0xBC, 0x11, 0x00, 0x00, 0x1F, 0x50]),
                    Data([0x16, 0x01, 0x00, 0x02, 0x27, 0x62, 0xDC, 0x05, 0xDC, 0x07, 0xA2, 0x12, 0x00, 0x00, 0x1E, 0x50]),
                    Data([0x08, 0x02, 0x00, 0x00, 0x27, 0x41, 0xDC, 0x01, 0x00, 0x00, 0x88, 0x13, 0x00, 0x00, 0x1D, 0x40]),
                    Data([0x08, 0x02, 0x00, 0x00, 0x27, 0x41, 0xDC, 0x01, 0x00, 0x00, 0xE8, 0x03, 0x00, 0x00, 0x1C, 0x40]),
                ])
            ])
        ]
        let cardData = OkicaCardData(idm: idm, systemCode: systemCode, data: data)
        let transactions = [
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/30", date: "2020-04-29 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "小禄", exitedStation: "那覇空港", balance: 1080, difference: -230, sequentialNumber: "47"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/18", date: "2020-04-17 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "首里", exitedStation: "小禄", balance: 1310, difference: -370, sequentialNumber: "46"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/17", date: "2020-04-16 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "てだこ浦西", exitedStation: "首里", balance: 1680, difference: -270, sequentialNumber: "45"),
            OkicaCardTransaction(type: .credit, otherType: nil, dateString: "2020/4/16", date: "2020-04-15 15:00:00 +0000".date, usageType: "ゆいレール（チャージ）", entryStation: "てだこ浦西", exitedStation: "", balance: 1950, difference: 1000, sequentialNumber: "44"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/15", date: "2020-04-14 15:00:00 +0000".date, usageType: "バス（移動）", entryStation: "琉球バス交通", exitedStation: "", balance: 950, difference: -680, sequentialNumber: "43"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/14", date: "2020-04-13 15:00:00 +0000".date, usageType: "バス（移動）", entryStation: "琉球バス交通", exitedStation: "", balance: 1630, difference: 0, sequentialNumber: "42"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/4/13", date: "2020-04-12 15:00:00 +0000".date, usageType: "バス（移動）", entryStation: "琉球バス交通", exitedStation: "", balance: 1630, difference: -680, sequentialNumber: "41"),
            OkicaCardTransaction(type: .credit, otherType: nil, dateString: "2020/4/12", date: "2020-04-11 15:00:00 +0000".date, usageType: "バス（チャージ）", entryStation: "琉球バス交通", exitedStation: "", balance: 2310, difference: -680, sequentialNumber: "40"),
            OkicaCardTransaction(type: .other, otherType: .pointExchange, dateString: "2020/4/11", date: "2020-04-10 15:00:00 +0000".date, usageType: "ポイントチャージ", entryStation: "古島", exitedStation: "", balance: 2990, difference: 60, sequentialNumber: "39"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2020/3/26", date: "2020-03-25 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "浦添前田", exitedStation: "てだこ浦西", balance: 2930, difference: -230, sequentialNumber: "38"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/25", date: "2019-11-24 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "石嶺", exitedStation: "経塚", balance: 3160, difference: -230, sequentialNumber: "37"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/24", date: "2019-11-23 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "儀保", exitedStation: "首里", balance: 3390, difference: -230, sequentialNumber: "36"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/23", date: "2019-11-22 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "古島", exitedStation: "市立病院前", balance: 3620, difference: -230, sequentialNumber: "35"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/22", date: "2019-11-21 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "安里", exitedStation: "おもろまち", balance: 3850, difference: -230, sequentialNumber: "34"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/5", date: "2019-11-04 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "美栄橋", exitedStation: "牧志", balance: 4080, difference: -236, sequentialNumber: "33"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/4", date: "2019-11-03 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "旭橋", exitedStation: "県庁前", balance: 4316, difference: -224, sequentialNumber: "32"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/3", date: "2019-11-02 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "奥武山公園", exitedStation: "壺川", balance: 4540, difference: -230, sequentialNumber: "31"),
            OkicaCardTransaction(type: .transit, otherType: nil, dateString: "2019/11/2", date: "2019-11-01 15:00:00 +0000".date, usageType: "ゆいレール（移動）", entryStation: "赤嶺", exitedStation: "小禄", balance: 4770, difference: -230, sequentialNumber: "30"),
            OkicaCardTransaction(type: .credit, otherType: nil, dateString: "2019/10/1", date: "2019-09-30 15:00:00 +0000".date, usageType: "ゆいレール（チャージ）", entryStation: "那覇空港", exitedStation: "", balance: 5000, difference: 4000, sequentialNumber: "29"),
        ]
        
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.okica)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.balance, 1080)
        XCTAssertNotNil(cardData.transactions)
        for (cardDataTransaction, dummyTransaction) in zip(cardData.transactions!, transactions) {
            XCTAssertEqual(cardDataTransaction.type, dummyTransaction.type)
            XCTAssertEqual(cardDataTransaction.otherType, dummyTransaction.otherType)
            XCTAssertEqual(cardDataTransaction.dateString, dummyTransaction.dateString)
            XCTAssertEqual(cardDataTransaction.date, dummyTransaction.date)
            XCTAssertEqual(cardDataTransaction.usageType, dummyTransaction.usageType)
            XCTAssertEqual(cardDataTransaction.entryStation, dummyTransaction.entryStation)
            XCTAssertEqual(cardDataTransaction.exitedStation, dummyTransaction.exitedStation)
            XCTAssertEqual(cardDataTransaction.balance, dummyTransaction.balance)
            XCTAssertEqual(cardDataTransaction.difference, dummyTransaction.difference)
            XCTAssertEqual(cardDataTransaction.sequentialNumber, dummyTransaction.sequentialNumber)
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
