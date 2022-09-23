//
//  NFCNDEFMessageReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/23.
//

import SwiftUI
import TRETNFCKit

struct NFCNDEFMessageReaderExampleView: View {
    private let reader = NFCNDEFMessageReader()
    
    var body: some View {
        List {
            Button {
                Task {
                    try await reader.read(invalidateAfterFirstRead: false, detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                        print(session.alertMessage)
                    } didDetectNDEFs: { session, messages in
                        print(messages)
                        return .success(alertMessage: "Done!")
                    }
                }
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("NDEF Messages")
    }
}
