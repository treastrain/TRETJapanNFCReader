// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TRETNFCKit",
    platforms: [.iOS(.v9), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v2)],
    products: [
        .library(
            name: "NFCKit",
            targets: ["NFCKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NFCKit",
            dependencies: []),
        .testTarget(
            name: "NFCKitTests",
            dependencies: ["NFCKit"]),
    ]
)