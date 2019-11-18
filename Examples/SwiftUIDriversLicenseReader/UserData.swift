//
//  UserData.swift
//  SwiftUIDriversLicenseReader
//
//  Created by Tomokatsu Onaga on 2019/11/18.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import Foundation
import Combine
import CoreNFC
import SwiftUI
import TRETJapanNFCReader


final class UserData: NSObject, ObservableObject, DriversLicenseReaderSessionDelegate {
    var reader: DriversLicenseReader?
    // @Published var pinSetting: Bool! = nil
    @Published var registeredDomicileString: String? = nil
    @Published var pinSettingString: String? = nil
    
    func driversLicenseReaderSession(didRead driversLicenseCard: DriversLicenseCard) {
        // スキャン完了時の処理
        self.publishCardInfo(driversLicenseCard)
    }
    
    func publishCardInfo(_ driversLicneceCard: DriversLicenseCard) {
        // DispatchQueue.main.async を使う理由は、UserData と ContentView が別スレッドで走っているため。代入処理をこれで囲む
        DispatchQueue.main.async {
            self.registeredDomicileString = driversLicneceCard.registeredDomicile?.registeredDomicile
            if let pinSetting = driversLicneceCard.pinSetting?.pinSetting {
                                self.pinSettingString = pinSetting ? "設定あり" : "設定なし"
            }
        }
        print("data has been published")
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        print("finished")
    }
    
    func startScan(items: [DriversLicenseCardItem], pin1: String = "", pin2: String = "") {
        self.reader?.get(items: items,
                         pin1: pin1, pin2: pin2)
        print("UserData startScan")
    }
    
    override init() {
        super.init()
        self.reader = DriversLicenseReader(delegate: self)
    }
}
