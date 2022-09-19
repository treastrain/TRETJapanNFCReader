//
//  ContentView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit

struct ContentView: View {
    private let reader = NFCTagReader()
    
    var body: some View {
        VStack {
            Image(systemName: "wave.3.forward.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Happy tag reading!")
        }
        .padding()
        .task {
            do {
                try await reader.read(pollingOption: .iso18092, detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session, tags in
                    let tag = tags.first!
                    try await session.connect(to: tag)
                    if case .feliCa(let feliCaTag) = tag {
                        session.alertMessage = "\(feliCaTag.currentIDm as NSData)"
                    } else {
                        session.alertMessage = "No FeliCa tag."
                    }
                    return .success
                }
            } catch {
            }
        }
    }
}
