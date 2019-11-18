//
//  PinSettingView.swift
//  SwiftUIDriversLicenseReader
//
//  Created by Tomokatsu Onaga on 2019/11/18.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import SwiftUI

struct PinSettingView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            List {
                if self.userData.pinSettingString != nil {
                    RecordView(key: "暗証番号(PIN)設定", value: self.userData.pinSettingString)
                }
            }.navigationBarTitle("暗証番号(PIN)設定")
                .onAppear(perform: {
                    self.userData.startScan(items: [.pinSetting])
            })
        }
    }
}

struct PinSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PinSettingView().environmentObject(UserData())
    }
}
