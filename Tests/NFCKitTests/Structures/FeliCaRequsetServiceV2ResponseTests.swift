//
//  FeliCaRequsetServiceV2ResponseTests.swift
//  TRETNFCKit
//
//  Created by treastrain on 2021/03/01.
//

import XCTest
#if os(iOS)
import CoreNFC
#endif
@testable import NFCKit

final class FeliCaRequsetServiceV2ResponseTests: XCTestCase, NFCKitTests {
    func testFeliCaRequsetServiceV2Response() throws {
        #if os(iOS) && !targetEnvironment(macCatalyst)
        guard #available(iOS 14.0, *) else {
            XCTFail("There is a problem with the OS version you are testing.")
            return
        }
        
        let coreChildValueHandler: ((Mirror.Child) -> AnyObject?) = { (coreChild) -> AnyObject? in
            switch coreChild.value {
            case let feliCaEncryptionId as NFCFeliCaEncryptionId:
                return feliCaEncryptionId.rawValue as AnyObject
            default:
                return nil
            }
        }
        
        var core = NFCFeliCaRequsetServiceV2Response(statusFlag1: 0, statusFlag2: 0, encryptionIdentifier: .AES, nodeKeyVersionListAES: nil, nodeKeyVersionListDES: nil)
        let kit = FeliCaRequsetServiceV2Response(from: core)
        testObjectConsistency(core, kit, coreChildValueHandler: coreChildValueHandler)
        
        core = NFCFeliCaRequsetServiceV2Response(from: kit)
        testObjectConsistency(core, kit, coreChildValueHandler: coreChildValueHandler)
        #else
        _ = FeliCaRequsetServiceV2Response(statusFlag1: 0, statusFlag2: 0, encryptionIdentifier: .AES, nodeKeyVersionListAES: nil, nodeKeyVersionListDES: nil)
        #endif
    }
}
