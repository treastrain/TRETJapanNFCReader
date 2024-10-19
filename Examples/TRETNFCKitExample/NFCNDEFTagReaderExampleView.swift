//
//  NFCNDEFTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/24.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_NDEFTag

struct NFCNDEFTagReaderExampleView: View {
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
            Button {
                Task {
                    try await viewModel.read()
                }
            } label: {
                Text("Read (using reader)")
            }
            Button {
                readerSession = NFCNDEFReaderSession(of: .tags, invalidateAfterFirstRead: false)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(readerSession != nil)
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
        .task(id: readerSession == nil) {
            defer { readerSession = nil }
            guard let readerSession else { return }
            guard NFCNDEFReaderSession.readingAvailable else { return }
            readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
            for await event in readerSession.tagEventStream {
                switch event {
                case .sessionBecomeActive:
                    break
                case .sessionDetected(let tags):
                    do {
                        print(tags)
                        let tag = tags.first!
                        try await readerSession.connect(to: tag)
                        let message = try await tag.readNDEF()
                        readerSession.alertMessage = "\(message)"
                        readerSession.invalidate()
                    } catch {
                        readerSession.invalidate(errorMessage: error.localizedDescription)
                    }
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
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
