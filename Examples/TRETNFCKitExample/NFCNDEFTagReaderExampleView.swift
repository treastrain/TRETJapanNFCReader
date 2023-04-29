//
//  NFCNDEFTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/24.
//

import SwiftUI
import TRETNFCKit_NDEFTag

struct NFCNDEFTagReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                isPresented = true
            } label: {
                Text("Read (using view modifier)")
            }
            Button {
                Task {
                    try await viewModel.read()
                }
            } label: {
                Text("Read")
            }
        }
        .nfcNDEFTagReader(
            isPresented: $isPresented,
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            onBeginReadingError: { error in
                print(error)
            },
            didBecomeActive: { reader in
                await print(reader.alertMessage)
            },
            didInvalidate: { error in
                print(error)
            },
            didDetectNDEFs: { reader, tags in
                let tag = tags.first!
                try await reader.connect(to: tag)
                let message = try await tag.readNDEF()
                await reader.set(alertMessage: "\(message)")
                return .success
            }
        )
        .navigationTitle("NDEF Tag")
    }
}

extension NFCNDEFTagReaderExampleView {
    final class ViewModel: ObservableObject {
        private var reader: NFCReader<NDEFTag>!
        
        func read() async throws {
            reader = .init()
            try await reader.read(
                detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
                didBecomeActive: { reader in
                    await print(reader.alertMessage)
                },
                didInvalidate: { error in
                    print(error)
                },
                didDetect: { reader, tags in
                    let tag = tags.first!
                    try await reader.connect(to: tag)
                    let message = try await tag.readNDEF()
                    await reader.set(alertMessage: "\(message)")
                    return .success
                }
            )
        }
    }
}
