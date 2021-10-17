// swift-tools-version:5.4

import PackageDescription

var products: [Product] = []
var targets: [Target] = []


// MARK: - NFCKit
do {
    let nfcKitTargets = [
        "NFCKitCore",
        "NFCKitTagReaderSession",
        "NFCKitNDEFReaderSession",
        "NFCKitISO7816Tag",
    ]
    products += [
        .library(name: "NFCKit", targets: nfcKitTargets),
        .library(name: "NFCKitStatic", type: .static, targets: nfcKitTargets),
        .library(name: "NFCKitDynamic", type: .dynamic, targets: nfcKitTargets),
    ]
}


// MARK: - NFCKitCore
products += [
    .library(name: "NFCKitCore", targets: ["NFCKitCore"]),
]
targets += [
    .target(name: "NFCKitCore", path: "Sources/NFCKit/NFCKitCore"),
    .testTarget(name: "NFCKitCoreTests", dependencies: ["NFCKitCore"]),
]


// MARK: - NFCKitTagReaderSession
products += [
    .library(name: "NFCKitTagReaderSession", targets: ["NFCKitTagReaderSession"]),
]
targets += [
    .target(name: "NFCKitTagReaderSession", dependencies: ["NFCKitCore"], path: "Sources/NFCKit/NFCKitTagReaderSession"),
]


// MARK: - NFCKitNDEFReaderSession
products += [
    .library(name: "NFCKitNDEFReaderSession", targets: ["NFCKitNDEFReaderSession"]),
]
targets += [
    .target(name: "NFCKitNDEFReaderSession", dependencies: ["NFCKitCore"], path: "Sources/NFCKit/NFCKitNDEFReaderSession"),
]


// MARK: - NFCKitISO7816Tag
products += [
    .library(name: "NFCKitISO7816Tag", targets: ["NFCKitISO7816Tag"]),
]
targets += [
    .target(name: "NFCKitISO7816Tag", dependencies: ["NFCKitCore"], path: "Sources/NFCKit/NFCKitISO7816Tag"),
]


// MARK: - NFCReader
/// The library name in `NFCReader`, which summarizes a country/region, is prefixed with the "English short name" as defined in ISO 3166-1:2020.
do {
    let nfcReaderTargets = [
        "JapanIndividualNumberCardReader",
    ]
    products += [
        .library(name: "NFCReader", targets: nfcReaderTargets),
        .library(name: "NFCReaderStatic", type: .static, targets: nfcReaderTargets),
        .library(name: "NFCReaderDynamic", type: .dynamic, targets: nfcReaderTargets),
    ]
}


// MARK: - JapanNFCReader
products += [
    .library(
        name: "JapanNFCReader",
        targets: [
            "JapanIndividualNumberCardReader",
        ]
    ),
]


// MARK: - JapanIndividualNumberCardReader
products += [
    .library(name: "JapanIndividualNumberCardReader", targets: ["JapanIndividualNumberCardReader"]),
]
targets += [
    .target(name: "JapanIndividualNumberCardReader", dependencies: ["NFCKitCore"], path: "Sources/NFCReader/JapanNFCReader/JapanIndividualNumberCardReader"),
]


let package = Package(
    name: "TRETNFCKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v9), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v2)],
    products: products,
    targets: targets
)
