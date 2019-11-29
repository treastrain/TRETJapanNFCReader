// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TRETJapanNFCReader",
    platforms: [
        .iOS("9.3"),
        .watchOS(.v2),
        .tvOS("9.2"),
        .macOS(.v10_10),
    ],
    products: [
        .library(
            name: "TRETJapanNFCReader",
            targets: ["TRETJapanNFCReader"]),
    ],
    targets: [
        .target(
            name: "TRETJapanNFCReader",
            dependencies: [],
            path: "TRETJapanNFCReader"),
    ],
    swiftLanguageVersions: [.v5]
)
