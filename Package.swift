// swift-tools-version:5.4

import PackageDescription

var products: [Product] = []
var targets: [Target] = []

var swiftWarnConcurrencySetting: [SwiftSetting]? {
#if compiler(>=5.5)
    return [.unsafeFlags(["-warn-concurrency"])]
#else
    return nil
#endif
}


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
    .target(
        name: "NFCKitCore",
        path: "Sources/NFCKit/NFCKitCore",
        swiftSettings: swiftWarnConcurrencySetting),
    .testTarget(
        name: "NFCKitCoreTests",
        dependencies: ["NFCKitCore"]),
]


// MARK: - NFCKitTagReaderSession
products += [
    .library(name: "NFCKitTagReaderSession", targets: ["NFCKitTagReaderSession"]),
]
targets += [
    .target(
        name: "NFCKitTagReaderSession",
        dependencies: ["NFCKitCore"],
        path: "Sources/NFCKit/NFCKitTagReaderSession",
        swiftSettings: swiftWarnConcurrencySetting),
]


// MARK: - NFCKitNDEFReaderSession
products += [
    .library(name: "NFCKitNDEFReaderSession", targets: ["NFCKitNDEFReaderSession"]),
]
targets += [
    .target(
        name: "NFCKitNDEFReaderSession",
        dependencies: ["NFCKitCore"],
        path: "Sources/NFCKit/NFCKitNDEFReaderSession",
        swiftSettings: swiftWarnConcurrencySetting),
]


// MARK: - NFCKitISO7816Tag
products += [
    .library(name: "NFCKitISO7816Tag", targets: ["NFCKitISO7816Tag"]),
]
targets += [
    .target(
        name: "NFCKitISO7816Tag",
        dependencies: ["NFCKitCore"],
        path: "Sources/NFCKit/NFCKitISO7816Tag",
        swiftSettings: swiftWarnConcurrencySetting),
]


let package = Package(
    name: "TRETNFCKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v9), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v2)],
    products: products,
    targets: targets
)
