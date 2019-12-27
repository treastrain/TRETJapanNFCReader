// swift-tools-version:5.1

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
            "TRETJapanNFCReader/Core",
            "TRETJapanNFCReader/FeliCa",
            // "TRETJapanNFCReader/MIFARE",
            "TRETJapanNFCReader/FeliCa/FCFCampus",
            "TRETJapanNFCReader/FeliCa/Nanaco",
            "TRETJapanNFCReader/FeliCa/NTasu",
            "TRETJapanNFCReader/FeliCa/Octopus",
            "TRETJapanNFCReader/FeliCa/Okica",
            "TRETJapanNFCReader/FeliCa/RakutenEdy",
            "TRETJapanNFCReader/FeliCa/Ryuto",
            "TRETJapanNFCReader/FeliCa/TransitIC",
            "TRETJapanNFCReader/MIFARE/DriversLicense",
        ],
        path: "Sources/TRETJapanNFCReader"),
]


// MARK: - Core
// Required for each targets
products.append(
    .library(
        name: "TRETJapanNFCReader/Core",
        targets: ["TRETJapanNFCReader/Core"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/Core",
        path: "Sources/Core")
)


// MARK: - FeliCa (ISO 18092)
// Required for targets using FeliCa (ISO 18092)
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa",
        targets: ["TRETJapanNFCReader/FeliCa"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa",
        dependencies: ["TRETJapanNFCReader/Core"],
        path: "Sources/FeliCa/_FeliCa")
)

/*
// MARK: - MIFARE (ISO 14443)
// Required for targets using MIFARE (ISO 14443)
将来的に他の MIFARE 系カードに対応したとき、共通なコードを "TRETJapanNFCReader/MIFARE/DriversLicense" から分割、分離し "TRETJapanNFCReader/MIFARE" とする。
products.append(
    .library(
        name: "TRETJapanNFCReader/MIFARE",
        targets: ["TRETJapanNFCReader/MIFARE"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/MIFARE",
        dependencies: ["TRETJapanNFCReader/Core"],
        path: "Sources/MIFARE/_MIFARE")
)
*/

// MARK: - FeliCa/FCFCampus
// FCFCampus
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/FCFCampus",
        targets: ["TRETJapanNFCReader/FeliCa/FCFCampus"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/FCFCampus",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/FCFCampus")
)


// MARK: - FeliCa/Nanaco
// nanaco
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/Nanaco",
        targets: ["TRETJapanNFCReader/FeliCa/Nanaco"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/Nanaco",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/Nanaco")
)


// MARK: - FeliCa/NTasu
// エヌタスTカード
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/NTasu",
        targets: ["TRETJapanNFCReader/FeliCa/NTasu"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/NTasu",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/NTasu")
)


// MARK: - FeliCa/Octopus
// 八達通 / Octopus
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/Octopus",
        targets: ["TRETJapanNFCReader/FeliCa/Octopus"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/Octopus",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/Octopus")
)


// MARK: - FeliCa/Okica
// OKICA
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/Okica",
        targets: ["TRETJapanNFCReader/FeliCa/Okica"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/Okica",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/Okica")
)


// MARK: - FeliCa/RakutenEdy
// 楽天Edy / Rakuten Edy
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/RakutenEdy",
        targets: ["TRETJapanNFCReader/FeliCa/RakutenEdy"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/RakutenEdy",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/RakutenEdy")
)


// MARK: - FeliCa/Ryuto
// りゅーと / Ryuto
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/Ryuto",
        targets: ["TRETJapanNFCReader/FeliCa/Ryuto"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/Ryuto",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/Ryuto")
)


// MARK: - FeliCa/TransitIC
// 交通系IC / Transit IC
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/TransitIC",
        targets: ["TRETJapanNFCReader/FeliCa/TransitIC"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/TransitIC",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/TransitIC")
)

/*
// MARK: - FeliCa/UnivCoopICPrepaid
// 大学生協ICプリペイド / Japanese Univ. Co-op IC Prepaid
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid",
        targets: ["TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/UnivCoopICPrepaid",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/UnivCoopICPrepaid")
)


// MARK: - FeliCa/Waon
// WAON
products.append(
    .library(
        name: "TRETJapanNFCReader/FeliCa/Waon",
        targets: ["TRETJapanNFCReader/FeliCa/Waon"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/FeliCa/Waon",
        dependencies: ["TRETJapanNFCReader/FeliCa"],
        path: "Sources/FeliCa/Waon")
)
*/

// MARK: - MIFARE/DriversLicense
// 日本の運転免許証 / Japanese Driver's License
products.append(
    .library(
        name: "TRETJapanNFCReader/MIFARE/DriversLicense",
        targets: ["TRETJapanNFCReader/MIFARE/DriversLicense"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader/MIFARE/DriversLicense",
        dependencies: [
            // 将来的に他の MIFARE 系カードに対応したとき、dependencies には "TRETJapanNFCReader/MIFARE" のみを指定する。"TRETJapanNFCReader/MIFARE" の dependencies に "TRETJapanNFCReader/Core" が含まれるため。
            /* "TRETJapanNFCReader/MIFARE" */
            "TRETJapanNFCReader/Core"
        ],
        path: "Sources/MIFARE/DriversLicense")
)


let package = Package(
    name: "TRETJapanNFCReader",
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
