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


// MARK: - NFCKitReader
/// The library name in `NFCKitReader`, which summarizes a country/region, is prefixed with the "English short name" as defined in ISO 3166-1:2020.
do {
    let nfcKitReaderTargets = [
        "JapanIndividualNumberCardReader",
    ]
    products += [
        .library(name: "NFCKitReader", targets: nfcKitReaderTargets),
        .library(name: "NFCKitReaderStatic", type: .static, targets: nfcKitReaderTargets),
        .library(name: "NFCKitReaderDynamic", type: .dynamic, targets: nfcKitReaderTargets),
    ]
}


// MARK: - NFCKitReaderCore
products += [
    .library(name: "NFCKitReaderCore", targets: ["NFCKitReaderCore"]),
]
targets += [
    .target(name: "NFCKitReaderCore", dependencies: ["NFCKitCore"], path: "Sources/NFCKitReader/NFCKitReaderCore"),
]


// MARK: - JapanNFCKitReader
products += [
    .library(
        name: "JapanNFCKitReader",
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
    .target(name: "JapanIndividualNumberCardReader", dependencies: ["NFCKitReaderCore", "NFCKitISO7816Tag"], path: "Sources/NFCKitReader/JapanNFCKitReader/JapanIndividualNumberCardReader"),
    .testTarget(name: "JapanIndividualNumberCardReaderTests", dependencies: ["JapanIndividualNumberCardReader"]),
]


let package = Package(
    name: "TRETNFCKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v9), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v2)],
    products: products,
    targets: targets
)
