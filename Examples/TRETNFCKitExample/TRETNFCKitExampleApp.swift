//
//  TRETNFCKitExampleApp.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

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
                        NavigationLink("Multiple") {
                            NFCNativeTagReaderExampleView()
                        }
                        NavigationLink("FeliCa") {
                            NFCFeliCaTagReaderExampleView()
                        }
                        NavigationLink("ISO 7816-compatible") {
                            NFCISO7816TagReaderExampleView()
                        }
                        NavigationLink("ISO 15693-compatible") {
                            NFCISO15693TagReaderExampleView()
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
