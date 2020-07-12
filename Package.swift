// swift-tools-version:5.3

import PackageDescription

var products: [Product] = [
    .library(
        name: "TRETJapanNFCReader",
        targets: ["TRETJapanNFCReader"])
]
var targets: [Target] = [
    .target(
        name: "TRETJapanNFCReader",
        dependencies: [
            "TRETJapanNFCReader-Core",
            "TRETJapanNFCReader-FeliCa",
        ],
        path: "Sources/TRETJapanNFCReader"),
]


// MARK: - Core
// Required for each targets
products.append(
    .library(
        name: "TRETJapanNFCReader-Core",
        targets: ["TRETJapanNFCReader-Core"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-Core",
        path: "Sources/Core")
)


// MARK: - FeliCa (ISO 18092)
// Required for targets using FeliCa (ISO 18092)
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa",
        targets: ["TRETJapanNFCReader-FeliCa"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa",
        dependencies: ["TRETJapanNFCReader-Core"],
        path: "Sources/FeliCa/_FeliCa")
)

let package = Package(
    name: "TRETJapanNFCReader",
    defaultLocalization: "en",
    platforms: [
        .iOS("9.3"),
        .watchOS(.v2),
        .tvOS("9.2"),
        .macOS(.v10_10),
    ],
    products: products,
    targets: targets,
    swiftLanguageVersions: [.v5]
)
