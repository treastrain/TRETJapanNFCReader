//
//  NFCNDEFMessageReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/23.
//

import SwiftUI
import TRETNFCKit_NDEFMessage

struct NFCNDEFMessageReaderExampleView: View {
    @State private var isPresented = false
    @ObservedObject var viewModel = ViewModel()
    
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
                Text("Read")
            }
        }
        .nfcNDEFMessageReader(
            isPresented: $isPresented,
            invalidateAfterFirstRead: false,
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            onBeginReadingError: { error in
                print(error)
            },
            didBecomeActive: { session in
                print(session.alertMessage)
            },
            didInvalidate: { error in
                print(error)
            },
            didDetectNDEFs: { session, messages in
                print(messages)
                return .success(alertMessage: "Done!")
            }
        )
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
                didBecomeActive: { session in
                    print(session)
                },
                didInvalidate: { error in
                    print(error)
                },
                didDetectNDEFs: { session, messages in
                    print(messages)
                    return .success(alertMessage: "Done!")
                }
            )
        }
    }
}
