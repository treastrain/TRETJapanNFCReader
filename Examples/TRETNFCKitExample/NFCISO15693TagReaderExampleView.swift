//
//  NFCISO15693TagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_ISO15693

struct NFCISO15693TagReaderExampleView: View {
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
                viewModel.read()
            } label: {
                Text("Read")
            }
        }
        .iso15693TagReader(
            isPresented: $isPresented,
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
            didDetect: { session, tags in
                let tag = tags.first!
                let iso15693Tag = try await session.connectAsISO15693Tag(to: tag)
                session.alertMessage = "\(iso15693Tag.identifier as NSData)"
                return .success
            }
        )
        .navigationTitle("ISO 15693-compatible")
    }
}

extension NFCISO15693TagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: ISO15693TagReader!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetect: { session, tags in
                    let tag = tags.first!
                    let iso15693Tag = try await session.connectAsISO15693Tag(to: tag)
                    session.alertMessage = "\(iso15693Tag.identifier as NSData)"
                    return .success
                }
            }
        }
    }
}
