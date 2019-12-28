//
//  DriversLicenseExtensions.swift
//  TRETJapanNFCReader
//
//  Created by treastrain on 2019/07/07.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
#if canImport(TRETJapanNFCReader_Core)
import TRETJapanNFCReader_Core
#endif

@available(iOS 13.0, *)
internal extension Optional where Wrapped == String {
    init(jisX0208Data: [[UInt8]]) {
        let dataArray = jisX0208Data.map { (data) -> Data in
            return ((UInt16(data[1]) << 8 + UInt16(data[0])) + 0x8080).data
        }
        var string = ""
        for data in dataArray {
            if let s = String(data: data, encoding: .japaneseEUC) {
                string += s
            } else {
                switch data {
                case Data([0xFF, 0xF1]):
                    string += "(外字1)"
                case Data([0xFF, 0xF2]):
                    string += "(外字2)"
                case Data([0xFF, 0xF3]):
                    string += "(外字3)"
                case Data([0xFF, 0xF4]):
                    string += "(外字4)"
                case Data([0xFF, 0xF5]):
                    string += "(外字5)"
                case Data([0xFF, 0xF6]):
                    string += "(外字6)"
                case Data([0xFF, 0xF7]):
                    string += "(外字7)"
                case Data([0xFF, 0xFA]):
                    string += "(欠字)"
                default:
                    string += "(未定義)"
                }
            }
        }
        self = string
    }
    
    func toDateFromJapanese() -> Date? {
        if var dateString = self {
            // 明治=1, 大正=2, 昭和=3, 平成=4, 令和=5
            switch dateString.first {
            case "1":
                dateString = "明治" + dateString.dropFirst()
            case "2":
                dateString = "大正" + dateString.dropFirst()
            case "3":
                dateString = "昭和" + dateString.dropFirst()
            case "4":
                dateString = "平成" + dateString.dropFirst()
            case "5":
                dateString = "令和" + dateString.dropFirst()
            default:
                break
            }
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja")
            formatter.calendar = Calendar(identifier: .japanese)
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            formatter.dateFormat = "GyyMMdd"
            
            let date = formatter.date(from: dateString)
            return date
        }
        return nil
    }
}

