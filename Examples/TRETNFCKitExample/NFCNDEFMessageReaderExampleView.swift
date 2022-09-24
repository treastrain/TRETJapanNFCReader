//
//  NFCNDEFMessageReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/23.
//

import SwiftUI
import TRETNFCKit_NDEFMessage

struct NFCNDEFMessageReaderExampleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("NDEF Messages")
    }
}

extension NFCNDEFMessageReaderExampleView {
    final class ViewModel: ObservableObject {
        private var reader: NFCReader<NDEFMessage>!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(invalidateAfterFirstRead: false, detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetectNDEFs: { session, messages in
                    print(messages)
                    return .success(alertMessage: "Done!")
                }
            }
        }
    }
}
