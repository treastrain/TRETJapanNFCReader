//
//  NFCISO7816TagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_ISO7816

struct NFCISO7816TagReaderExampleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("ISO 7816-compatible")
    }
}

extension NFCISO7816TagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: ISO7816TagReader!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetect: { session, tags in
                    let tag = tags.first!
                    let iso7816Tag = try await session.connectAsISO7816Tag(to: tag)
                    session.alertMessage = "\(iso7816Tag.identifier as NSData)"
                    return .success
                }
            }
        }
    }
}
