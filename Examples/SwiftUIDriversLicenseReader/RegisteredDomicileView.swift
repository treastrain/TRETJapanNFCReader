//
//  RegisteredDomicileView.swift
//  SwiftUIDriversLicenseReader
//
//  Created by Tomokatsu Onaga on 2019/11/18.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import SwiftUI

struct RegisteredDomicileView: View {
    @EnvironmentObject var userData: UserData
    @State var pin1: String = ""
    @State var pin2: String = ""
    var body: some View {
        NavigationView {
            List {
                if self.userData.registeredDomicileString != nil {
                    RecordView(key: "本籍", value: self.userData.registeredDomicileString)
                }
                SecureField("暗証番号1", text:$pin1).keyboardType(.numbersAndPunctuation)
                SecureField("暗証番号2", text:$pin2).keyboardType(.numbersAndPunctuation)
                Button(action: {
                    self.userData.startScan(items: [.registeredDomicile], pin1: self.pin1, pin2: self.pin2)
                }) {
                    Text("スキャン").foregroundColor(.blue)
                }.disabled(self.pin1.count != 4)
                .disabled(self.pin2.count != 4)
            }.navigationBarTitle("記載事項（本籍）")
        }
    }
}

struct RegisteredDomicileView_Previews: PreviewProvider {
    static var previews: some View {
        RegisteredDomicileView().environmentObject(UserData())
    }
}
