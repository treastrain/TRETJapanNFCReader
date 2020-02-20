//
//  FeliCaSystemCode.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/10/10.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

public typealias FeliCaSystemCode = UInt16

public extension FeliCaSystemCode {
    
    init(from systemCodeData: Data) {
        let bytes = [systemCodeData[1], systemCodeData[0]] /// Little Endian (LE)
        self = UnsafePointer(bytes).withMemoryRebound(to: FeliCaSystemCode.self, capacity: 1) {
            $0.pointee
        }
    }
    
    var string: String {
        return self.toHexString()
    }
    
    /// 日本鉄道サイバネティクス協議会（CJRC）規格
    static let cjrc: FeliCaSystemCode = 0x0003
    /// ナイスパス
    static let nicePass: FeliCaSystemCode = 0x040F
    /// QUICPay
    static let quicpay: FeliCaSystemCode = 0x04C1
    /// nanaco
    static let nanaco: FeliCaSystemCode = 0x04C7
    /// NFC Data Exchange Format (NDEF)
    static let ndef: FeliCaSystemCode = 0x12FC
    /// Host-based Card Emulation for NFC-F (HCE-F)
    static let hcef: FeliCaSystemCode = 0x4000
    /// 深圳通 (Shenzhen Tong)
    static let shenzhenTong: FeliCaSystemCode = 0x8005
    /// 八達通 (Octopus)
    static let octopus: FeliCaSystemCode = 0x8008
    /// ひまわりバスカード
    static let himawariBus: FeliCaSystemCode = 0x800D
    /// 長崎スマートカード
    static let nagasakiSmart: FeliCaSystemCode = 0x8016
    /// ICバスカード 北海道北見バス
    static let kitamiBus: FeliCaSystemCode = 0x804C
    /// LuLuCa
    static let luluca: FeliCaSystemCode = 0x804C // 0x04A6 もある
    /// 近江鉄道バスICカード
    static let ohmiRailwayBus: FeliCaSystemCode = 0x8074
    /// IruCa
    static let iruca: FeliCaSystemCode = 0x80DE
    /// ですか
    static let desuca: FeliCaSystemCode = 0x80E0
    /// ICい〜カード
    static let icE: FeliCaSystemCode = 0x80E0
    /// ICa
    static let ica: FeliCaSystemCode = 0x80EF
    /// CI-CA
    static let cica: FeliCaSystemCode = 0x8157
    /// いわさきICカード
    static let iwasaki: FeliCaSystemCode = 0x8194
    /// RapiCa
    static let rapica: FeliCaSystemCode = 0x8194
    /// NicoPa
    static let nicopa: FeliCaSystemCode = 0x8287
    /// passca
    static let passca: FeliCaSystemCode = 0x832C
    /// ecomyca
    static let ecomyca: FeliCaSystemCode = 0x832C
    /// Hareca
    static let hareca: FeliCaSystemCode = 0x83CC
    /// ayuca
    static let ayuca: FeliCaSystemCode = 0x83EE
    /// hanica
    static let hanica: FeliCaSystemCode = 0x84A1
    /// EX-IC
    static let exic: FeliCaSystemCode = 0x854C
    /// PASPY
    static let paspy: FeliCaSystemCode = 0x8592
    /// itappy
    static let itappy: FeliCaSystemCode = 0x862C
    /// SAPICA
    static let sapica: FeliCaSystemCode = 0x865E
    /// Suica
    static let suica: FeliCaSystemCode = 0x86A7
    /// Felicitous Common use Format (FCF)
    static let fcf: FeliCaSystemCode = 0x8760
    /// FeliCa Lite/FeliCa Lite-S
    static let lite: FeliCaSystemCode = 0x88B4
    /// NORUCA
    static let noruca: FeliCaSystemCode = 0x8B43
    /// りゅーと
    static let ryuto: FeliCaSystemCode = 0x8B5D
    /// 楽天Edy
    static let rakutenEdy: FeliCaSystemCode = 0x8B61
    /// らんでんカード
    static let randen: FeliCaSystemCode = 0x8B98
    /// 大学生協ICプリペイド
    static let univCoopICPrepaid: FeliCaSystemCode = 0x8E4B
    /// OKICA
    static let okica: FeliCaSystemCode = 0x8FC1
    /// くまもんのIC CARD
    static let kumamotoIC: FeliCaSystemCode = 0x9027
    /// はやかけん
    static let hayakaken: FeliCaSystemCode = 0x927A
    /// エヌタスTカード
    static let ntasu: FeliCaSystemCode = 0x93EC
    /// FeliCa 共通領域
    static let common: FeliCaSystemCode = 0xFE00
    /// FeliCa Plug
    static let plug: FeliCaSystemCode = 0xFEE1
    
    
    @available(*, unavailable, renamed: "cjrc")
    static let japanRailwayCybernetics: FeliCaSystemCode = 0x0003
}
