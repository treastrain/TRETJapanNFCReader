//
//  NFCNDEFTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/24.
//

import SwiftUI
import TRETNFCKit_NDEFTag

struct NFCNDEFTagReaderExampleView: View {
    @State private var isPresented = false
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
                readerSession = NFCNDEFReaderSession(of: .tags, invalidateAfterFirstRead: false)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(!NFCNDEFReaderSession.readingAvailable || readerSession != nil)
        }
        .nfcNDEFTagReader(
            isPresented: $isPresented,
            invalidateAfterFirstRead: false,
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
                    let message = try await tag.readNDEF()
                    readerSession.alertMessage = "\(message)"
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
