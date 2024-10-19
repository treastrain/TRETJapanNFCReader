//
//  NFCFeliCaTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_FeliCa

struct NFCFeliCaTagReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    @State private var readerSession: NFCTagReaderSession?
    
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
                Text("Read (using reader)")
            }
            Button {
                readerSession = NFCTagReaderSession(pollingOption: .iso18092)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(readerSession != nil)
        }
        .feliCaTagReader(
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
                let feliCaTag = try await reader.connectAsFeliCaTag(to: tag)
                let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                await reader.set(alertMessage: "\(systemCode as NSData)\n\(idm as NSData)")
                return .success
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
                    do {
                        let tag = tags.first!
                        guard case .feliCa(let feliCaTag) = tag else {
                            throw NFCReaderError(.readerErrorInvalidParameter)
                        }
                        try await readerSession.connect(to: tag)
                        let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                        readerSession.alertMessage = "\(systemCode as NSData)\n\(idm as NSData)"
                        readerSession.invalidate()
                    } catch {
                        readerSession.invalidate(errorMessage: error.localizedDescription)
                    }
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .navigationTitle("FeliCa")
    }
}

extension NFCFeliCaTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: FeliCaTagReader!
        
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
                    let feliCaTag = try await reader.connectAsFeliCaTag(to: tag)
                    let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                    await reader.set(alertMessage: "\(systemCode as NSData)\n\(idm as NSData)")
                    return .success
                }
            )
        }
    }
}
