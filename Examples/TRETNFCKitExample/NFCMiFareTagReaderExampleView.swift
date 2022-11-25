//
//  NFCMiFareTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_MiFare

struct NFCMiFareTagReaderExampleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("ISO 15693-compatible")
    }
}

extension NFCMiFareTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: MiFareTagReader!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetect: { session, tags in
                    let tag = tags.first!
                    let miFareTag = try await session.connectAsMiFareTag(to: tag)
                    session.alertMessage = "\(miFareTag.identifier as NSData)"
                    return .success
                }
            }
        }
    }
}
