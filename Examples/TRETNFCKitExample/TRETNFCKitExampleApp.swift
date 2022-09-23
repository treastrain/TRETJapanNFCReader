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
                        NavigationLink("NDEF Tag") {
                            NFCNDEFTagReaderExampleView()
                        }
                    } header: {
                        Text("NDEF (NFC Data Exchange Format)")
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
