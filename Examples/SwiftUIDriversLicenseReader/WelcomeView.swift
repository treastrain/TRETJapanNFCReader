//
//  WelcomeView.swift
//  SwiftUIDriversLicenseReader
//
//  Created by Tomokatsu Onaga on 2019/11/18.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PinSettingView()) {
                    Text("共通データ要素")
                }
                NavigationLink(destination: PinSettingView()) {
                    Text("暗証番号(PIN)設定")
                }
                NavigationLink(destination: PinSettingView()) {
                    Text("記載事項（本籍除く）")
                }
                NavigationLink(destination: PinSettingView()) {
                    Text("記載事項（本籍）")
                }
                NavigationLink(destination: PinSettingView()) {
                    Text("写真")
                }
            }.navigationBarTitle("運転免許リーダ")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
