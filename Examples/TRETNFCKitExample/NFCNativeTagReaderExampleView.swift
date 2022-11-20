//
//  NFCNativeTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_NativeTag

struct NFCNativeTagReaderExampleView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            Button {
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .navigationTitle("Multiple")
    }
}

extension NFCNativeTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: NFCReader<NativeTag>!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(pollingOption: [.iso14443, .iso15693, .iso18092], detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetect: { session, tags in
                    let tag = tags.first!
                    try await session.connect(to: tag)
                    switch tag {
                    case .feliCa(let feliCaTag):
                        session.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
                    case .iso7816(let iso7816Tag):
                        session.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
                    case .iso15693(let iso15693Tag):
                        session.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
                    case .miFare(let miFareTag):
                        session.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
                    @unknown default:
                        session.alertMessage = "Unknown tag."
                    }
                    return .success
                }
            }
        }
    }
}
