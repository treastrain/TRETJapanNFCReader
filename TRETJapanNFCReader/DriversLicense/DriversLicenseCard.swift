//
//  DriversLicenseCard.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/06/29.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import CoreNFC

/// 日本の運転免許証から読み取ることができるデータの種別
public enum DriversLicenseCardItems {
    case commonData
}

/// 日本の運転免許証
public struct DriversLicenseCard {
    internal var tag: DriversLicenseCardTag
    
    /// MF/EF01 にある共通データ要素
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
    /// MF/EF01 にある共通データ要素
    public var commonData: CommonData?
    
    /*
    // MF/EF02 暗証番号(PIN)設定
    var 暗証番号設定: Bool
    
    // MF/IEF01 暗証番号1(PIN 1)
    var 暗証番号1: Int
    
    // MF/IEF02 暗証番号2(PIN 2)
    var 暗証番号2: Int
    
    // DF1/EF01 記載事項(本籍除く)
    var JISX0208制定年番号: Int
    var 氏名: String
    var 呼び名（カナ）: String
    var 通称名: String
    var 統一氏名: String
    var 生年月日: Date
    var 住所: String
    var 交付年月日: Date
    var 照会番号: Int
    var 免許証の色区分（優良・新規・その他）: String
    var 有効期間の末日: Date
    var 免許の条件1: String
    var 免許の条件2: String
    var 免許の条件3: String
    var 免許の条件4: String
    var 公安委員会名: String
    var 免許証の番号: String
    var 免許の年月日（二・小・原）: Date
    var 免許の年月日（他）: Date
    var 免許の年月日（二種）: Date
    var 免許の年月日（大型）: Date
    var 免許の年月日（普通）: Date
    var 免許の年月日（大特）: Date
    var 免許の年月日（大自二）: Date
    var 免許の年月日（普自二）: Date
    var 免許の年月日（小特）: Date
    var 免許の年月日（原付）: Date
    var 免許の年月日（け引）: Date
    var 免許の年月日（大二）: Date
    var 免許の年月日（普二）: Date
    var 免許の年月日（大特二）: Date
    var 免許の年月日（け引二）: Date
    var 免許の年月日（中型）: Date
    var 免許の年月日（中二）: Date
    var 免許の年月日（準中型）: Date
    
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
}

public extension Optional where Wrapped == Date {
    func toString() -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        if self == nil {
            return nil
        } else {
            return formatter.string(from: self!)
        }
    }
}

public extension UInt8 {
    func toString() -> String{
        var str = String(self, radix: 16).uppercased()
        if str.count == 1 {
            str = "0" + str
        }
        return str
    }
    
    func toHexString() -> String {
        var str = self.toString()
        str = "0x\(str)"
        return str
    }
}

public extension Optional where Wrapped == UInt8 {
    func toHexString() -> String? {
        if self == nil {
            return nil
        } else {
            return self!.toHexString()
        }
    }
}
