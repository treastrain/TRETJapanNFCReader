//
//  NFCNativeTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_NativeTag

struct NFCNativeTagReaderExampleView: View {
    @State private var isPresented = false
    @State private var readerSession: NFCTagReaderSession?
    
    var body: some View {
        List {
            Button {
                isPresented = true
            } label: {
                Text("Read (using view modifier)")
            }
            .disabled(!NFCTagReaderSession.readingAvailable || isPresented)
            Button {
                readerSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693, .iso18092])
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(!NFCTagReaderSession.readingAvailable || readerSession != nil)
        }
        .nfcNativeTagReader(
            isPresented: $isPresented,
            pollingOption: [.iso14443, .iso15693, .iso18092],
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            terminatingAlertMessage: "CANCELLED",
            onDidBecomeActive: { readerSession in
                print(readerSession.alertMessage)
            },
            onDidDetect: { readerSession, tags in
                print(tags)
                do {
                    let tag = tags.first!
                    try await readerSession.connect(to: tag)
                    switch tag {
                    case .feliCa(let feliCaTag):
                        readerSession.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
                    case .iso7816(let iso7816Tag):
                        readerSession.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
                    case .iso15693(let iso15693Tag):
                        readerSession.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
                    case .miFare(let miFareTag):
                        readerSession.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
                    @unknown default:
                        readerSession.alertMessage = "Unknown tag."
                    }
                    readerSession.invalidate()
                } catch {
                    readerSession.invalidate(errorMessage: error.localizedDescription)
                }
            },
            onDidInvalidate: { error in
                print(error)
            }
        )
        .task(id: readerSession == nil) {
            defer { readerSession = nil }
            guard let readerSession else { return }
            guard NFCTagReaderSession.readingAvailable else { return }
            readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
            for await event in readerSession.eventStream {
                switch event {
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let tags):
                    let tag = tags.first!
                    do {
                        try await readerSession.connect(to: tag)
                        switch tag {
                        case .feliCa(let feliCaTag):
                            readerSession.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
                        case .iso7816(let iso7816Tag):
                            readerSession.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
                        case .iso15693(let iso15693Tag):
                            readerSession.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
                        case .miFare(let miFareTag):
                            readerSession.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
                        @unknown default:
                            readerSession.alertMessage = "Unknown tag."
                        }
                        readerSession.invalidate()
                    } catch {
                        readerSession.invalidate(errorMessage: error.localizedDescription)
                    }
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .navigationTitle("Multiple")
    }
}
