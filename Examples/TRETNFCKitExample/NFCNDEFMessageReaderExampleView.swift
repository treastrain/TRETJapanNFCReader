//
//  NFCNDEFMessageReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/23.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_NDEFMessage

struct NFCNDEFMessageReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    @State private var readerSession: NFCNDEFReaderSession?
    
    var body: some View {
        List {
            Button {
                isPresented = true
            } label: {
                Text("Read (using view modifier)")
            }
            .disabled(!NFCNDEFReaderSession.readingAvailable || isPresented)
            Button {
                Task {
                    try await viewModel.read()
                }
            } label: {
                Text("Read (using reader)")
            }
            Button {
                readerSession = NFCNDEFReaderSession(of: .messages, invalidateAfterFirstRead: false)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(!NFCNDEFReaderSession.readingAvailable || readerSession != nil)
        }
        .nfcNDEFMessageReader(
            isPresented: $isPresented,
            invalidateAfterFirstRead: false,
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            terminatingAlertMessage: "CANCELLED",
            onDidBecomeActive: { readerSession in
                print(readerSession.alertMessage)
            },
            onDidDetect: { readerSession, messages in
                print(messages)
                readerSession.alertMessage = "Done!"
                readerSession.invalidate()
            },
            onDidInvalidate: { error in
                print(error)
            }
        )
        .task(id: readerSession == nil) {
            defer { readerSession = nil }
            guard let readerSession else { return }
            guard NFCNDEFReaderSession.readingAvailable else { return }
            readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
            for await event in readerSession.messageEventStream {
                switch event {
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let messages):
                    print(messages)
                    readerSession.alertMessage = "Done!"
                    readerSession.invalidate()
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .navigationTitle("NDEF Messages")
    }
}

extension NFCNDEFMessageReaderExampleView {
    final class ViewModel: ObservableObject {
        private var reader: NFCReader<NDEFMessage>!
        
        func read() async throws {
            reader = .init()
            try await reader.read(
                invalidateAfterFirstRead: false,
                detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
                didBecomeActive: { reader in
                    print(reader)
                },
                didInvalidate: { error in
                    print(error)
                },
                didDetectNDEFs: { reader, messages in
                    print(messages)
                    return .success(alertMessage: "Done!")
                }
            )
        }
    }
}
