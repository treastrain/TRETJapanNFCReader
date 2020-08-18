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
            "TRETJapanNFCReader-FeliCa-Nanaco",
            // "TRETJapanNFCReader-FeliCa-Octopus",
            // "TRETJapanNFCReader-FeliCa-Okica",
            "TRETJapanNFCReader-FeliCa-RakutenEdy",
            // "TRETJapanNFCReader-FeliCa-Ryuto",
            "TRETJapanNFCReader-FeliCa-TransitIC",
            "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
            // "TRETJapanNFCReader-FeliCa-Waon",
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


// MARK: - FeliCa-Nanaco
// nanaco / nanaco
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Nanaco",
        targets: ["TRETJapanNFCReader-FeliCa-Nanaco"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Nanaco",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Nanaco/Sources")
)
targets.append(
    .testTarget(
        name: "TRETJapanNFCReader-FeliCa-NanacoTests",
        dependencies: ["TRETJapanNFCReader-FeliCa-Nanaco"],
        path: "Sources/FeliCa/Nanaco/Tests")
)


// MARK: - FeliCa-RakutenEdy
// Rakuten Edy / 楽天Edy
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-RakutenEdy",
        targets: ["TRETJapanNFCReader-FeliCa-RakutenEdy"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-RakutenEdy",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/RakutenEdy/Sources")
)
targets.append(
    .testTarget(
        name: "TRETJapanNFCReader-FeliCa-RakutenEdyTests",
        dependencies: ["TRETJapanNFCReader-FeliCa-RakutenEdy"],
        path: "Sources/FeliCa/RakutenEdy/Tests")
)


// MARK: - FeliCa-TransitIC
// Transit IC (comply or correspond with CJRC standards) / 交通系IC (CJRC規格準拠または対応)
// Suica, ICOCA, PiTaPa, IruCa, TOICA, PASMO, PASPY, nimoca, Kitaca, SAPICA, SUGOCA, はやかけん, manaca, icsca, etc.
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-TransitIC",
        targets: ["TRETJapanNFCReader-FeliCa-TransitIC"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-TransitIC",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/TransitIC/Sources")
)
targets.append(
    .testTarget(
        name: "TRETJapanNFCReader-FeliCa-TransitICTests",
        dependencies: ["TRETJapanNFCReader-FeliCa-TransitIC"],
        path: "Sources/FeliCa/TransitIC/Tests")
)


// MARK: - FeliCa-UnivCoopICPrepaid
// Japanese Univ. Co-op IC Prepaid / 大学生協ICプリペイド
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
        targets: ["TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/UnivCoopICPrepaid/Sources")
)
targets.append(
    .testTarget(
        name: "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaidTests",
        dependencies: ["TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid"],
        path: "Sources/FeliCa/UnivCoopICPrepaid/Tests")
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
