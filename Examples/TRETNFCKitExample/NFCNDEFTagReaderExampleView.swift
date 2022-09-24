//
//  NFCNDEFTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/24.
//

import SwiftUI
import TRETNFCKit_NDEFTag

struct NFCNDEFTagReaderExampleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("NDEF Tag")
    }
}

extension NFCNDEFTagReaderExampleView {
    final class ViewModel: ObservableObject {
        private var reader: NFCReader<NDEFTag>!
        
        func read() {
            Task {
                reader = .init()
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
        }
    }
}
