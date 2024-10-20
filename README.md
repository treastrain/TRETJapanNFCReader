<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/assets/tretnfckit-header_dark.png">
  <source media="(prefers-color-scheme: light)" srcset=".github/assets/tretnfckit-header_light.png">
  <img alt="TRETNFCKit, A wrapper for Core NFC and a useful helper when using NFC, leveraging Swift features for Apple platforms (iOS etc.)" src=".github/assets/tretnfckit-header_light.png">
</picture>

# TRETNFCKit
A wrapper for Core NFC and a useful helper when using NFC, leveraging Swift features for Apple platforms. \
(Renamed from `treastrain/TRETJapanNFCReader`)

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/treastrain/TRETJapanNFCReader/blob/master/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/treastrain/TRETJapanNFCReader)](https://github.com/treastrain/TRETJapanNFCReader/stargazers) \
![Platform: iOS & iPadOS|macOS|tvOS|watchOS|visionOS](https://img.shields.io/badge/Platform-iOS%20%26%20iPadOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS-lightgrey.svg)
![SwiftUI compatible](https://img.shields.io/badge/SwiftUI-compatible-brightgreen.svg) \
![Swift: 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) \
[![X (formerly Twitter): @treastrain](https://img.shields.io/twitter/follow/treastrain?label=%40treastrain&style=social)](https://twitter.com/treastrain) \
[![Swift Build & Test](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/swift.yml/badge.svg?branch=tretnfckit-main)](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/swift.yml)
[![Xcode Build & Test](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild.yml/badge.svg?branch=tretnfckit-main)](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild.yml)
[![Example App Build](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild_for_example_app.yml/badge.svg?branch=tretnfckit-main)](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild_for_example_app.yml)

# Features
- ✅ Asynchronous sequence for NFC tag reading, which is very similar to [`CardSession.eventStream`](https://developer.apple.com/documentation/corenfc/cardsession/4318517-eventstream) (provided by Core NFC in iOS 17.4+, which allows communication with HCE-based NFC readers based on ISO 7816-4)
  - `NFCNDEFReaderSession.messageEventStream` / `NFCNDEFReaderSession.tagEventStream`
  - `NFCTagReaderSession.eventStream`
  - `NFCVASReaderSession.responseEventStream`
- ✅ SwiftUI compatible
  - `nfcNDEFMessageReader`: NDEF messages
  - `nfcNDEFTagReader`: NDEF tags
  - `nfcNativeTagReader`: NFC-A/B, NFC-F
  - `feliCaTagReader`: FeliCa (NFC-F)
  - `iso7816TagReader`: ISO 7816-compatible (NFC-A/B)
  - `iso15693TagReader`: ISO 15693-compatible (NFC-V)
  - `miFareTagReader`: MiFare (MIFARE Plus, UltraLight, DESFire) base on ISO 14443 (NFC-A)

# Usage
## Asynchronous sequence for NFC tag reading
```swift
import TRETNFCKit

func tagReaderSample() async {
    guard NFCTagReaderSession.readingAvailable else { return }
    guard let readerSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693, .iso18092]) else { return }
    readerSession.alertMessage = "Place the tag on a flat, non-metal surface and rest your iPhone on the tag."
    for await event in readerSession.eventStream {
        switch event {
        case .sessionBecomeActive:
            break
        case .sessionDetected(let tags):
            let tag = tags.first!
            do {
                try await readerSession.connect(to: tag)
                switch tag {
                case .feliCa(let feliCaTag):
                    readerSession.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
                case .iso7816(let iso7816Tag):
                    readerSession.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
                case .iso15693(let iso15693Tag):
                    readerSession.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
                case .miFare(let miFareTag):
                    readerSession.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
                @unknown default:
                    readerSession.alertMessage = "Unknown tag."
                }
                readerSession.invalidate()
            } catch {
                readerSession.invalidate(errorMessage: error.localizedDescription)
            }
        case .sessionInvalidated(_):
            break
        }
    }
}
```

## For SwiftUI wrapper
```swift
import TRETNFCKit

struct NFCNativeTagReaderExampleView: View {
    @State private var isPresented = false
    
    var body: some View {
        List {
            Button("Read") {
                isPresented = true
            }
            .disabled(!NFCTagReaderSession.readingAvailable || isPresented)
        }
        .nfcNativeTagReader(
            isPresented: $isPresented,
            pollingOption: [.iso14443, .iso15693, .iso18092],
            detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
            onDidBecomeActive: { _ in /* ... */ },
            onDidDetect: { readerSession, tags in
                do {
                    let tag = tags.first!
                    try await readerSession.connect(to: tag)
                    switch tag {
                    case .feliCa(let feliCaTag):
                        readerSession.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
                    case .iso7816(let iso7816Tag):
                        readerSession.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
                    case .iso15693(let iso15693Tag):
                        readerSession.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
                    case .miFare(let miFareTag):
                        readerSession.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
                    @unknown default:
                        readerSession.alertMessage = "Unknown tag."
                    }
                    readerSession.invalidate()
                } catch {
                    readerSession.invalidate(errorMessage: error.localizedDescription)
                }
            },
            onDidInvalidate: { _ in /* ... */ }
        )
    }
}
```

# Availability
- iOS 13.0+
- iPadOS 13.0+
- macOS 10.15+
- Mac Catalyst 13.0+
- tvOS 13.0+
- watchOS 6.0+
- visionOS 1.0+
- Xcode 16.0+
  - Swift 6.0+

> [!NOTE]
> Features related to NFC tag reading are only available in iOS 13.0+.

# License
MIT License

# Notices
The names of e-money and the services are generally trademarks and registered trademarks of each company. This library is not officially provided by service providers and others.
