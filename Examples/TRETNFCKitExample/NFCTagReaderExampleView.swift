//
//  NFCTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit

struct NFCTagReaderExampleView: View {
    private let reader = NFCTagReader()
    
    var body: some View {
        List {
            Button {
                Task {
                    try await reader.read(pollingOption: .iso18092, detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                        print(session.alertMessage)
                    } didDetect: { session, tags in
                        let tag = tags.first!
                        try await session.connect(to: tag)
                        if case .feliCa(let feliCaTag) = tag {
                            session.alertMessage = "\(feliCaTag.currentIDm as NSData)"
                        } else {
                            session.alertMessage = "No FeliCa tag."
                        }
                        return .success
                    }
                }
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("FeliCa")
    }
}
