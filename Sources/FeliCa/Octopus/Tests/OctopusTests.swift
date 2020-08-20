//
//  OctopusTests.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/08/20.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import XCTest
import TRETJapanNFCReader_FeliCa
@testable import TRETJapanNFCReader_FeliCa_Octopus

final class OctopusTests: XCTestCase {
    func testOctopusCardDataInit() {
        let systemCode = FeliCaSystemCode.octopus
        let idm = "0101080118176b0e"
        let pmm = "0120220427674eff"
        let data: FeliCaData = [
            systemCode : FeliCaSystem(systemCode: systemCode, idm: idm, pmm: pmm, services: [
                0x0117 : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x00, 0x00, 0x01, 0x5A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17])
                ]),
                0x100B : FeliCaBlockData(status1: 0, status2: 0, blockData: [
                    Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
                ])
            ])
        ]
        let cardData = OctopusCardData(idm: idm, systemCode: systemCode, data: data)
        XCTAssertEqual(cardData.version, "3")
        XCTAssertEqual(cardData.type, FeliCaCardType.octopus)
        XCTAssertEqual(cardData.primaryIDm, idm)
        XCTAssertEqual(cardData.primarySystemCode, systemCode)
        XCTAssertEqual(cardData.contents, data)
        XCTAssertNotNil(cardData.balance)
        let balance = (Double(cardData.balance!) - 500) / 10.0
        XCTAssertEqual(balance, -15.4)
    }
}
