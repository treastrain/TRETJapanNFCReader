//
//  NFCNDEFMessageReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/23.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_Async
import TRETNFCKit_NDEFMessage

struct NFCNDEFMessageReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    @State private var readerSession: AsyncNFCNDEFMessageReaderSession?
    @State private var newReaderSesssion: NFCNDEFReaderSession?
    
    var body: some View {
        List {
            Button {
                isPresented = true
            } label: {
                Text("Read (using reader view modifier)")
            }
            Button {
                Task {
                    try await viewModel.read()
                }
            } label: {
                Text("Read (using reader)")
            }
            Button {
                readerSession = AsyncNFCNDEFMessageReaderSession(invalidateAfterFirstRead: false)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(readerSession != nil)
            Button {
                newReaderSesssion = NFCNDEFReaderSession(of: .messages, invalidateAfterFirstRead: false)
            } label: {
                Text("Read (using new async stream)")
            }
            .disabled(newReaderSesssion != nil)
        }
        .nfcNDEFMessageReader(
            isPresented: $isPresented,
            invalidateAfterFirstRead: false,
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
            didDetectNDEFs: { reader, messages in
                print(messages)
                return .success(alertMessage: "Done!")
            }
        )
        .task(id: readerSession == nil) {
            defer { readerSession = nil }
            guard let readerSession else { return }
            guard AsyncNFCNDEFMessageReaderSession.readingAvailable else { return }
            
            for await event in readerSession.eventStream {
                switch event {
                case .sessionIsReady:
                    readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
                    readerSession.start()
                case .sessionStarted:
                    break
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let messages):
                    print(messages)
                    readerSession.alertMessage = "Done!"
                    readerSession.stop()
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .task(id: newReaderSesssion == nil) {
            defer { newReaderSesssion = nil }
            guard let newReaderSesssion else { return }
            guard NFCNDEFReaderSession.readingAvailable else { return }
            newReaderSesssion.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
            for await event in newReaderSesssion.messageEventStream {
                switch event {
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let messages):
                    print(messages)
                    newReaderSesssion.alertMessage = "Done!"
                    newReaderSesssion.invalidate()
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
