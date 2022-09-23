//
//  TRETNFCKitExampleApp.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import TRETNFCKit
import SwiftUI

@main
struct TRETNFCKitExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    Section {
                        NavigationLink("NDEF Messages") {
                            NFCNDEFMessageReaderExampleView()
                        }
                    } header: {
                        Text("NDEF")
                    }
                    
                    Section {
                        NavigationLink("FeliCa") {
                            NFCTagReaderExampleView()
                        }
                    } header: {
                        Text("Native")
                    }
                }
                .navigationBarTitle("TRETNFCKit")
            }
        }
    }
}
