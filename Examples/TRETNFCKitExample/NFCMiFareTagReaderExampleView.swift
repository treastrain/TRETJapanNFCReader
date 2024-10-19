//
//  NFCMiFareTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_Core
import TRETNFCKit_MiFare

struct NFCMiFareTagReaderExampleView: View {
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
                readerSession = NFCTagReaderSession(pollingOption: .iso14443)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(!NFCTagReaderSession.readingAvailable || readerSession != nil)
        }
        .miFareTagReader(
            isPresented: $isPresented,
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            terminatingAlertMessage: "CANCELLED",
            onDidBecomeActive: { readerSession in
                print(readerSession.alertMessage)
            },
            onDidDetect: { readerSession, tags in
                do {
                    let tag = tags.first!
                    let miFareTag = try await readerSession.connectAsMiFareTag(to: tag)
                    readerSession.alertMessage = "\(miFareTag.identifier as NSData)"
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
                    do {
                        let tag = tags.first!
                        guard case .miFare(let miFareTag) = tag else {
                            throw NFCReaderError(.readerErrorInvalidParameter)
                        }
                        try await readerSession.connect(to: tag)
                        readerSession.alertMessage = "\(miFareTag.identifier as NSData)"
                        readerSession.invalidate()
                    } catch {
                        readerSession.invalidate(errorMessage: error.localizedDescription)
                    }
                case .sessionInvalidated(let reason):
                    print(reason)
                }
            }
        }
        .navigationTitle("MiFare")
    }
}
