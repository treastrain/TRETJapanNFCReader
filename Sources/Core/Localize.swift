//
//  Localize.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2020/01/01.
//  Copyright © 2020 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation

public var kJapanNFCReaderLocalizedLanguage: LocalizedLanguage = .ja
public var kJapanNFCReaderLocalizedStringsBundle: Bundle? = nil

public enum LocalizedLanguage {
    case ja
    case en
    case zhHans
    case zhHant
    case zhHK
    
    case key
}

public struct LocalizedItem {
    let key: String
    let ja: String
    let en: String
    let zhHans: String
    let zhHant: String
    let zhHK: String
    
    public func string() -> String {
        class SelfClass {}
        let bundle = kJapanNFCReaderLocalizedStringsBundle ?? Bundle(for: type(of: SelfClass()))
        let localizedString = NSLocalizedString(self.key, bundle: bundle, comment: "")
        
        if localizedString != self.key {
            return localizedString
        }
        
        switch kJapanNFCReaderLocalizedLanguage {
        case .ja:
            return self.ja
        case .en:
            return self.en
        case .zhHans:
            return self.zhHans
        case .zhHant:
            return self.zhHant
        case .zhHK:
            return self.zhHK
        case .key:
            return self.key
        }
    }
}

public enum Localized {
    
    public static let nfcReadingUnavailableAlertTitle = LocalizedItem(
        key: "nfcReadingUnavailableAlertTitle",
        ja: "読み取りを開始できません",
        en: "Scanning Not Supported",
        zhHans: "不支持扫描",
        zhHant: "不支援掃描",
        zhHK: "不支援掃描"
    )
    
    public static let nfcReadingUnavailableAlertMessage = LocalizedItem(
        key: "nfcReadingUnavailableAlertMessage",
        ja: "この端末ではNFCのスキャンや検出をすることができません。",
        en: "This device doesn't support NFC scanning.",
        zhHans: "此装置不支持扫描。",
        zhHant: "此裝置不支援掃描。",
        zhHK: "此裝置不支援掃描。"
    )
    
    public static let nfcReaderSessionAlertMessage = LocalizedItem(
        key: "nfcReaderSessionAlertMessage",
        ja: "上図に表示されている通りに、カードの下半分を隠すように iPhone をその上に置いてください。",
        en: "Rest your iPhone on the bottom half of the card, as shown above.",
        zhHans: "如图中所示将 iPhone 放在卡的下半部份。",
        zhHant: "如圖中所示將 iPhone 放在卡的下半部份。",
        zhHK: "如圖中所示將 iPhone 放在卡的下半部份。"
    )
    
    public static let nfcTagReaderSessionDidInvalidateWithErrorAlertTitle = LocalizedItem(
        key: "nfcTagReaderSessionDidInvalidateWithErrorAlertTitle",
        ja: "セッションが無効になりました",
        en: "The session has been invalidated",
        zhHans: "此程序已无效",
        zhHant: "此程序已無效",
        zhHK: "此程序已失效"
    )
    
    public static let nfcTagReaderSessionDidDetectTagsMoreThan1TagIsDetectedMessage = LocalizedItem(
        key: "nfcTagReaderSessionDidDetectTagsMoreThan1TagIsDetectedMessage",
        ja: "複数のカードが検出されました。すべてのカードを取り除いてもう一度やり直してください。",
        en: "More than 1 card is detected. Please remove all cards and try again.",
        zhHans: "检测到多于一张卡。请移除所有卡然后重新再试。",
        zhHant: "偵測到多於一張卡。請移除所有卡然後重新再試。",
        zhHK: "偵測到多於一張卡。請移除所有卡然後重新再試。"
    )
    
    public static let nfcTagReaderSessionConnectErrorMessage = LocalizedItem(
        key: "nfcTagReaderSessionConnectErrorMessage",
        ja: "接続エラーです。もう一度やり直してください。",
        en: "Connection error. Please try again.",
        zhHans: "连接错误。请重试。",
        zhHant: "連接錯誤。請重試。",
        zhHK: "連接錯誤。請重試。"
    )
    
    public static let nfcTagReaderSessionDifferentTagTypeErrorMessage = LocalizedItem(
        key: "nfcTagReaderSessionDifferentTagTypeErrorMessage",
        ja: "読み取り対象ではないカードが検出されました。もう一度やり直してください。",
        en: "A card that is not to read is detected, please try again.",
        zhHans: "检测到不能读取的卡。 请重试。",
        zhHant: "偵測到不能讀取的卡。 請再試一次。",
        zhHK: "偵測到不能讀取的卡。 請再試一次。"
    )
    
    public static let nfcTagReaderSessionReadingMessage = LocalizedItem(
        key: "nfcTagReaderSessionReadingMessage",
        ja: "読み取り中…\n カードを iPhone から離さないでください。",
        en: "Reading…\n Keep your iPhone resting on the card.",
        zhHans: "读取中…\n 将 iPhone 放在卡片上保持不动。",
        zhHant: "讀取中…\n 將 iPhone 放在卡片上保持不動。",
        zhHK: "讀取中…\n 將 iPhone 放在卡片上保持不動。"
    )
    
    public static let nfcTagReaderSessionDoneMessage = LocalizedItem(
        key: "nfcTagReaderSessionDoneMessage",
        ja: "完了",
        en: "Done!",
        zhHans: "完成",
        zhHant: "完成",
        zhHK: "完成"
    )
    
    public static let pinRequired = LocalizedItem(
        key: "pinRequired",
        ja: "暗証番号の入力が必要です",
        en: "PIN required.",
        zhHans: "需要输入 PIN 码",
        zhHant: "需要輸入 PIN 碼",
        zhHK: "需要輸入 PIN 碼"
    )
    
    public static let transitIC = LocalizedItem(
        key: "transitIC",
        ja: "交通系IC",
        en: "Transit IC",
        zhHans: "交通 IC",
        zhHant: "交通 IC",
        zhHK: "交通 IC"
    )
    
    public static let rakutenEdy = LocalizedItem(
        key: "rakutenEdy",
        ja: "楽天Edy",
        en: "Rakuten Edy",
        zhHans: "乐天 Edy",
        zhHant: "樂天 Edy",
        zhHK: "樂天 Edy"
    )
    
    public static let univCoopICPrepaid = LocalizedItem(
        key: "univCoopICPrepaid",
        ja: "大学生協ICプリペイド",
        en: "Univ. Co-op",
        zhHans: "大学生协会预付 IC",
        zhHant: "大學生協會預付 IC",
        zhHK: "大學生協會預付 IC"
    )
    
    public static let ryuto = LocalizedItem(
        key: "ryuto",
        ja: "りゅーと",
        en: "Ryuto",
        zhHans: "Ryuto",
        zhHant: "Ryuto",
        zhHK: "Ryuto"
    )
    
    public static let octopus = LocalizedItem(
        key: "octopus",
        ja: "オクトパス（八達通）",
        en: "Octopus (八達通)",
        zhHans: "八达通",
        zhHant: "八達通",
        zhHK: "八達通"
    )
}
