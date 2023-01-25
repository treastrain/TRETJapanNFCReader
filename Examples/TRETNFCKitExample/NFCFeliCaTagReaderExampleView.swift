//
//  NFCFeliCaTagReaderExampleView.swift
//  TRETNFCKitExample
//
//  Created by treastrain on 2022/09/20.
//

import SwiftUI
import TRETNFCKit_FeliCa

struct NFCFeliCaTagReaderExampleView: View {
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
        .feliCaTagReader(
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
                let feliCaTag = try await session.connectAsFeliCaTag(to: tag)
                let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                session.alertMessage = "\(systemCode as NSData)\n\(idm as NSData)"
                return .success
            }
        )
        .navigationTitle("FeliCa")
    }
}

extension NFCFeliCaTagReaderExampleView {
    final class ViewModel : ObservableObject {
        private var reader: FeliCaTagReader!
        
        func read() {
            Task {
                reader = .init()
                try await reader.read(detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.") { session in
                    print(session.alertMessage)
                } didDetect: { session, tags in
                    let tag = tags.first!
                    let feliCaTag = try await session.connectAsFeliCaTag(to: tag)
                    let (idm, systemCode) = try await feliCaTag.polling(systemCode: Data([0xFE, 0x00]), requestCode: .systemCode, timeSlot: .max1)
                    session.alertMessage = "\(systemCode as NSData)\n\(idm as NSData)"
                    return .success
                }
            }
        }
    }
}
