//
//  NFCISO15693TagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_Async
import TRETNFCKit_ISO15693

struct NFCISO15693TagReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    @State private var readerSession: AsyncNFCTagReaderSession?
    
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
                readerSession = AsyncNFCTagReaderSession(pollingOption: .iso15693)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(readerSession != nil)
        }
        .iso15693TagReader(
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
                let iso15693Tag = try await reader.connectAsISO15693Tag(to: tag)
                await reader.set(alertMessage: "\(iso15693Tag.identifier as NSData)")
                return .success
            }
        )
        .task(id: readerSession == nil) {
            defer { readerSession = nil }
            guard let readerSession else { return }
            guard AsyncNFCTagReaderSession.readingAvailable else { return }
            
            for await event in readerSession.eventStream {
                switch event {
                case .sessionIsReady:
                    readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
                    readerSession.start()
                case .sessionStarted:
                    break
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let tags):
                    do {
                        let tag = tags.first!
                        guard case .iso15693(let iso15693Tag) = tag else {
                            throw NFCReaderError(.readerErrorInvalidParameter)
                        }
                        try await readerSession.connect(to: tag)
                        readerSession.alertMessage = "\(iso15693Tag.identifier as NSData)"
                        readerSession.stop()
                    } catch {
                        readerSession.stop(errorMessage: error.localizedDescription)
                    }
                case .sessionCreationFailed(let reason):
                    print(reason)
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .navigationTitle("ISO 15693-compatible")
    }
}

extension NFCISO15693TagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: ISO15693TagReader!
        
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
                    let iso15693Tag = try await reader.connectAsISO15693Tag(to: tag)
                    await reader.set(alertMessage: "\(iso15693Tag.identifier as NSData)")
                    return .success
                }
            )
        }
    }
}
