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
![Platform: iOS & iPadOS|macOS|tvOS|watchOS](https://img.shields.io/badge/Platform-iOS%20%26%20iPadOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)
![Swift: 5.7](https://img.shields.io/badge/Swift-5.7-orange.svg) \
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Twitter: @treastrain](https://img.shields.io/twitter/follow/treastrain?label=%40treastrain&style=social)](https://twitter.com/treastrain) \
[![Swift Build & Test](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/swift.yml/badge.svg?branch=tretnfckit-main)](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/swift.yml)
[![Xcode Build & Test](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild.yml/badge.svg?branch=tretnfckit-main)](https://github.com/treastrain/TRETJapanNFCReader/actions/workflows/xcodebuild.yml)

# Usage
- ✅ No delegation pattern
  - When using Core NFC directly, it is usually a delegation pattern. In this case, this is unsafe because it is possible to forget to call a necessary command.
  - By using this wrapper, it can be converted to a closure pattern compatible with Swift Concurrency, and the Swift syntax prevents forgetting to call the necessary commands.
- ✅ Support Swift Concurrency (async/await, Actor, Sendable)

## Native Tags (FeliCa (NFC-F), ISO 7816-compatible (NFC-A/B), ISO 15693-compatible (NFC-V), MiFare (NFC-A))
### FeliCa (NFC-F)
```swift
let reader: FeliCaTagReader()
try await reader.read(
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        let feliCaTag = try await session.connectAsFeliCaTag(to: tag)
        let (statusFlag1, statusFlag2, blockData) = try await feliCaTag.readWithoutEncryption(serviceCodeList: /* ... */, blockList: /* ... */)
        print(statusFlag1, statusFlag2, blockData)
        return .success(alertMessage: "Done!")
    }
}
```

### ISO 7816-compatible (NFC-A/B)
```swift
let reader: ISO7816TagReader()
try await reader.read(
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        let iso7816Tag = try await session.connectAsISO7816Tag(to: tag)
        print(iso7816Tag.identifier)
        // ...
        return .success(alertMessage: "Done!")
    }
}
```

### ISO 15693-compatible (NFC-V)
```swift
let reader: ISO15693TagReader()
try await reader.read(
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        let iso15693Tag = try await session.connectAsISO15693Tag(to: tag)
        print(iso15693Tag.identifier)
        // ...
        return .success(alertMessage: "Done!")
    }
}
```

### MiFare (MIFARE Plus, UltraLight, DESFire) base on ISO 14443 (NFC-A)
```swift
let reader: MiFareTagReader()
try await reader.read(
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        let miFareTag = try await session.connectAsMiFareTag(to: tag)
        print(miFareTag.identifier)
        // ...
        return .success(alertMessage: "Done!")
    }
}
```

### Use directly
```swift
let reader = NFCReader<NativeTag>()
try await reader.read(
    pollingOption: [.iso14443, .iso15693, .iso18092], // You can combine options to have the reader session scan and detect different tag types at the same time.
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        try await session.connect(to: tag)
        switch tag {
        case .feliCa(let feliCaTag):
            session.alertMessage = "FeliCa\n\(feliCaTag.currentIDm as NSData)"
        case .iso7816(let iso7816Tag):
            session.alertMessage = "ISO14443-4 type A / B tag with ISO7816\n\(iso7816Tag.identifier as NSData)"
        case .iso15693(let iso15693Tag):
            session.alertMessage = "ISO 15693\n\(iso15693Tag.identifier as NSData)"
        case .miFare(let miFareTag):
            session.alertMessage = "MiFare technology tag (MIFARE Plus, UltraLight, DESFire) base on ISO14443\n\(miFareTag.identifier as NSData)"
        }
        return .success
    }
)
```

## NDEF Tags
```swift
let reader = NFCReader<NDEFTag>()
try await reader.read(
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetect: { session, tags in
        let tag = tags.first!
        try await session.connect(to: tag)
        let message = try await tag.readNDEF()
        print(message)
        return .success(alertMessage: "Done!")
    }
)
```

## NDEF Messages
```swift
let reader = NFCReader<NDEFMessage>()
try await reader.read(
    invalidateAfterFirstRead: true,
    detectingAlertMessage: "Place the tag on a flat, non-metal surface and rest your iPhone on the tag.",
    didDetectNDEFs: { _, messages in
        print(messages)
        return .success(alertMessage: "Done!")
    }
)
```

# Availability
- iOS 13.0+
- iPadOS 13.0+
- macOS 10.15+
- Mac Catalyst 13.0+
- tvOS 13.0+
- watchOS 6.0+
- Xcode 14.0+
  - Swift 5.7+

**:warning:　Features related to NFC tag reading are only available in iOS 13.0+.　:warning:**

# License
MIT License

# Notices
The names of e-money and the services are generally trademarks and registered trademarks of each company. This library is not officially provided by service providers and others.
