//
//  NFCISO7816TagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_ISO7816

struct NFCISO7816TagReaderExampleView: View {
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
        .iso7816TagReader(
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
            didDetect: { reader, tags in
                let tag = tags.first!
                let iso7816Tag = try await reader.connectAsISO7816Tag(to: tag)
                await reader.set(alertMessage: "\(iso7816Tag.identifier as NSData)")
                return .success
            }
        )
        .navigationTitle("ISO 7816-compatible")
    }
}

extension NFCISO7816TagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: ISO7816TagReader!
        
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
                    let iso7816Tag = try await reader.connectAsISO7816Tag(to: tag)
                    await reader.set(alertMessage: "\(iso7816Tag.identifier as NSData)")
                    return .success
                }
            )
        }
    }
}
