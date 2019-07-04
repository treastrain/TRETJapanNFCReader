//
//  DriversLicenseCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

/// 日本の運転免許証から読み取ることができるデータの種別
public enum DriversLicenseCardItems: CaseIterable {
    /// MF/EF01 共通データ要素
    case commonData
    /// MF/EF02 暗証番号(PIN)設定
    case pinSetting
    /// DF1/EF01 記載事項(本籍除く)
    case matters
}

/// 日本の運転免許証
public struct DriversLicenseCard {
    internal var tag: DriversLicenseCardTag
    
    /// MF/EF01 共通データ要素
    public struct CommonData {
        /// 仕様書バージョン番号
        public var specificationVersionNumber: String
        /// 交付年月日
        public var issuanceDate: Date
        /// 有効期間の末日
        public var expirationDate: Date
        /// カード製造業者識別子
        public var cardManufacturerIdentifier: UInt8
        /// 暗号関数識別子
        public var cryptographicFunctionIdentifier: UInt8
    }
    /// MF/EF01 共通データ要素
    public var commonData: CommonData?
    
    /// MF/EF02 暗証番号(PIN)設定
    public struct PINSetting {
        /// 暗証番号(PIN)設定
        public var pinSetting: Bool
    }
    /// MF/EF02 暗証番号(PIN)設定
    public var pinSetting: PINSetting?
    
    /// DF1/EF01 記載事項(本籍除く)
    public struct Matters {
        /// JISX0208制定年番号
        public var jisX0208EstablishmentYearNumber: String
        /// 氏名
        public var name: String
        /// 呼び名(カナ)
        public var nickname: String
        /// 通称名
        public var commonName: String?
        /// 統一氏名(カナ)
        public var uniformName: String
        /// 生年月日
        public var birthdate: Date
        /// 住所
        public var address: String
        /// 交付年月日
        public var issuanceDate: Date
        /// 照会番号
        public var referenceNumber: String
        /// 免許証の色区分(優良・新規・その他)
        public var color: String
        /// 有効期間の末日
        public var expirationDate: Date
        /// 免許の条件1
        public var condition1: String?
        /// 免許の条件2
        public var condition2: String?
        /// 免許の条件3
        public var condition3: String?
        /// 免許の条件4
        public var condition4: String?
        /// 公安委員会名
        public var issuingAuthority: String
        /// 免許証の番号
        public var number: String
        /// 免許の年月日(二・小・原)
        public var motorcycleLicenceDate: Date?
        /// 免許の年月日(他)
        public var otherLicenceDate: Date?
        /// 免許の年月日(二種)
        public var class2LicenceDate: Date?
        /// 免許の年月日(大型)
        public var heavyVehicleLicenceDate: Date?
        /// 免許の年月日(普通)
        public var ordinaryVehicleLicenceDate: Date?
        /// 免許の年月日(大特)
        public var heavySpecialVehicleLicenceDate: Date?
        /// 免許の年月日(大自二)
        public var heavyMotorcycleLicenceDate: Date?
        /// 免許の年月日(普自二)
        public var ordinaryMotorcycleLicenceDate: Date?
        /// 免許の年月日(小特)
        public var smallSpecialVehicleLicenceDate: Date?
        /// 免許の年月日(原付)
        public var mopedLicenceDate: Date?
        /// 免許の年月日(け引)
        public var trailerLicenceDate: Date?
        /// 免許の年月日(大二)
        public var class2HeavyVehicleLicenceDate: Date?
        /// 免許の年月日(普二)
        public var class2OrdinaryVehicleLicenceDate: Date?
        /// 免許の年月日(大特二)
        public var class2HeavySpecialVehicleLicenceDate: Date?
        /// 免許の年月日(け引二)
        public var class2TrailerLicenceDate: Date?
        /// 免許の年月日(中型)
        public var mediumVehicleLicenceDate: Date?
        /// 免許の年月日(中二)
        public var class2MediumVehicleLicenceDate: Date?
        /// 免許の年月日(準中型)
        public var semiMediumVehicleLicenceDate: Date?
    }
    /// DF1/EF01 記載事項(本籍除く)
    public var matters: Matters?
    
    /*
    
    // DF1/EF02 記載事項(本籍)
    var 本籍: String
    
    // DF1/EF03 外字
    var 文字構成1: Int
    var 外字1: Data
    var 文字構成2: Int
    var 外字2: Data
    
    // DF1/EF04 記載事項変更等(本籍除く)
    var 追記の有無: Bool
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 住所地公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 新氏名: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 新呼び名: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 新住所: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 新条件: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 条件解除: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 備考: String
    var 公安委員会名: String
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 予備: String
    var 公安委員会名: String
    
    // DF1/EF05 記載事項変更(外字)
    var 追記の有無: Bool
    var 文字構成3: Int
    var 外字3: Data
    var 文字構成4: Int
    var 外字4: Data
    var 文字構成5: Int
    var 外字5: Data
    var 文字構成6: Int
    var 外字6: Data
    var 文字構成7: Int
    var 外字7: Data
    
    // DF1/EF06 記載事項変更(本籍)
    var 追記の有無: Bool
    var JISX0208制定年番号: Int
    var 変更年月日: Date
    var 新本籍: String
    var 公安委員会名: String
    
    // DF1/EF07 電子署名
    var 電子署名: Data
    var シリアル番号: String
    var 発行者名: String
    var 主体者名: String
    var 主体者鍵識別子: UInt8
    
    // DF2/EF01 写真
    var 写真: Data
    
    // DF3/EF01 RFU
    */
    
    typealias TLVField = (tag: UInt8, length: UInt8, value: [UInt8])
    
    internal func convert(items: DriversLicenseCardItems, from data: [UInt8]) -> DriversLicenseCard {
        var driversLicenseCard = self
        var fields: [TLVField] = []
        
        var i = 0
        while i < data.count {
            let tag = data[i]
            if tag == 0xFF {
                break
            }
            i += 1
            let length = data[i]
            if length == 0 {
                i += 1
                continue
            }
            i += 1
            let endIndex = Int(length) + i - 1
            let value = data[i...endIndex].map {$0}
            i = endIndex + 1
            
            let valueString = value.map { (u) -> String in u.toHexString() }
            print("タグ: \(tag.toHexString()), 長さ: \(length), 値: \(valueString)")
            
            fields.append((tag: tag, length: length, value: value))
        }
        
        switch items {
        case .matters:
            // self.convertToMatters(fields: fields)
            break
        default:
            break
        }
        
        return driversLicenseCard
    }
}

