//
//  RecordView.swift
//  SwiftUIDriversLicenseReader
//
//  Created by Tomokatsu Onaga on 2019/11/18.
//  Copyright © 2019 treastrain / Tanaka Ryoga. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    var key: String
    var value: String?
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            if (value != nil) {Text(value!).bold()}
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecordView(key: "本籍")
        }
    }
}
