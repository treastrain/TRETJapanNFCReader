//
//  NFCNDEFTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/24.
//

import SwiftUI
import TRETNFCKit

struct NFCNDEFTagReaderExampleView: View {
    private let reader = NFCNDEFTagReader()
    
    var body: some View {
        List {
            Button {
                Task {
                    try await reader.read(detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                        print(session.alertMessage)
                    } didDetect: { session, tags in
                        let tag = tags.first!
                        try await session.connect(to: tag)
                        let message = try await tag.readNDEF()
                        session.alertMessage = "\(message)"
                        return .success
                    }
                }
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("NDEF Tag")
    }
}
