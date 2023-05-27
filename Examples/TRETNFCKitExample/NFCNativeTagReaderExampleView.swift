//
//  NFCNativeTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_NativeTag

struct NFCNativeTagReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Text("Read (using view modifier)")
                    Spacer()
                    if isPresented { ProgressView() }
                }
            }
            .disabled(isPresented)
            Button {
                Task {
                    try await viewModel.read()
                }
            } label: {
                Text("Read")
            }
        }
        .nfcNativeTagReader(
            isPresented: $isPresented,
            pollingOption: [.iso14443, .iso15693, .iso18092],
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
                try await reader.connect(to: tag)
                switch tag {
                case .feliCa(let feliCaTag):
                    await reader.set(alertMessage: "FeliCa\n\(feliCaTag.currentIDm as NSData)")
                case .iso7816(let iso7816Tag):
                    await reader.set(alertMessage: "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)")
                case .iso15693(let iso15693Tag):
                    await reader.set(alertMessage: "ISO 15693\n\(iso15693Tag.identifier as NSData)")
                case .miFare(let miFareTag):
                    await reader.set(alertMessage: "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)")
                @unknown default:
                    await reader.set(alertMessage: "Unknown tag.")
                }
                return .success
            }
        )
        .navigationTitle("Multiple")
    }
}

extension NFCNativeTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: NFCReader<NativeTag>!
        
        func read() async throws {
            reader = .init()
            try await reader.read(
                pollingOption: [.iso14443, .iso15693, .iso18092],
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
                    switch tag {
                    case .feliCa(let feliCaTag):
                        await reader.set(alertMessage: "FeliCa\n\(feliCaTag.currentIDm as NSData)")
                    case .iso7816(let iso7816Tag):
                        await reader.set(alertMessage: "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)")
                    case .iso15693(let iso15693Tag):
                        await reader.set(alertMessage: "ISO 15693\n\(iso15693Tag.identifier as NSData)")
                    case .miFare(let miFareTag):
                        await reader.set(alertMessage: "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)")
                    @unknown default:
                        await reader.set(alertMessage: "Unknown tag.")
                    }
                    return .success
                }
            )
        }
    }
}
