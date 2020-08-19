//
//  TransitICTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/09.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_TransitIC

final class TransitICTests: XCTestCase {
    func testTransitICCardDataInit() {
        let systemCode = FeliCaSystemCode.sapica
        let idm = "01120312f31a5f1b"
        let pmm = "0136428247459aff"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                TransitICCardItemType.balance.parameter(systemCode: systemCode).serviceCode : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x23, 0x00, 0x00, 0xd4, 0x03, 0x00, 0x00, 0x07])
                ]),
                TransitICCardItemType.sapicaPoints.parameter(systemCode: systemCode).serviceCode : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x34, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00])
                ])
            ])
        ]
        let cardData = TransitICCardData(idm: idm, systemCode: systemCode, data: data)
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.transitIC)
        XCTAssertEqual(cardData.primaryIDm, "01120312f31a5f1b")
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertEqual(cardData.balance, 980)
        XCTAssertEqual(cardData.sapicaPoints, 52)
    }
}
