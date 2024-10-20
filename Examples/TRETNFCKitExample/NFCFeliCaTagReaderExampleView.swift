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
                readerSession = NFCTagReaderSession(pollingOption: .iso18092)
            } label: {
                Text("Read (using async stream)")
            }
            .disabled(!NFCTagReaderSession.readingAvailable || readerSession != nil)
        }
        .feliCaTagReader(
            isPresented: $isPresented,
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            terminatingAlertMessage: "CANCELLED",
            onDidBecomeActive: { readerSession in
                print(readerSession.alertMessage)
            },
            onDidDetect: { readerSession, tags in
                do {
                    let tag = tags.first!
                    let feliCaTag = try await readerSession.connectAsFeliCaTag(to: tag)
                    let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                    readerSession.alertMessage = "\(systemCode as NSData)\n\(idm as NSData)"
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
                        let feliCaTag = try await readerSession.connectAsFeliCaTag(to: tag)
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
