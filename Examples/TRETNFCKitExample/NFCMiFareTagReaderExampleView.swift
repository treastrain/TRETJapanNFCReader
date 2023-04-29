//
//  NFCMiFareTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_MiFare

struct NFCMiFareTagReaderExampleView: View {
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
        .miFareTagReader(
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
                let miFareTag = try await reader.connectAsMiFareTag(to: tag)
                await reader.set(alertMessage: "\(miFareTag.identifier as NSData)")
                return .success
            }
        )
        .navigationTitle("MiFare")
    }
}

extension NFCMiFareTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: MiFareTagReader!
        
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
                    let miFareTag = try await reader.connectAsMiFareTag(to: tag)
                    await reader.set(alertMessage: "\(miFareTag.identifier as NSData)")
                    return .success
                }
            )
        }
    }
}
