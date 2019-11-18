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
                Text("共通データ要素").foregroundColor(.gray)
                NavigationLink(destination: PinSettingView().environmentObject(UserData())) {
                    Text("暗証番号(PIN)設定")
                }
                Text("記載事項（本籍除く）").foregroundColor(.gray)
                NavigationLink(destination: RegisteredDomicileView().environmentObject(UserData())) {
                    Text("記載事項（本籍）")
                }
                Text("写真").foregroundColor(.gray)
            }.navigationBarTitle("運転免許リーダ")
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
