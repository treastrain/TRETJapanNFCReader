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
                    Text("PIN setting")
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
