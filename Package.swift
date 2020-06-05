// swift-tools-version:5.2

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
            "TRETJapanNFCReader-ISO7816",
            "TRETJapanNFCReader-FeliCa-FCFCampus",
            "TRETJapanNFCReader-FeliCa-Nanaco",
            "TRETJapanNFCReader-FeliCa-NTasu",
            "TRETJapanNFCReader-FeliCa-Octopus",
            "TRETJapanNFCReader-FeliCa-Okica",
            "TRETJapanNFCReader-FeliCa-RakutenEdy",
            "TRETJapanNFCReader-FeliCa-Ryuto",
            "TRETJapanNFCReader-FeliCa-TransitIC",
            "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
            "TRETJapanNFCReader-FeliCa-Waon",
            "TRETJapanNFCReader-ISO7816-DriversLicense",
            "TRETJapanNFCReader-ISO7816-IndividualNumber",
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


// MARK: - ISO7816 (ISO 14443)
// Required for targets using ISO7816 (ISO 14443)
products.append(
    .library(
        name: "TRETJapanNFCReader-ISO7816",
        targets: ["TRETJapanNFCReader-ISO7816"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-ISO7816",
        dependencies: ["TRETJapanNFCReader-Core"],
        path: "Sources/ISO7816/_ISO7816")
)


// MARK: - FeliCa-FCFCampus
// FCFCampus
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-FCFCampus",
        targets: ["TRETJapanNFCReader-FeliCa-FCFCampus"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-FCFCampus",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/FCFCampus")
)


// MARK: - FeliCa-Nanaco
// nanaco
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Nanaco",
        targets: ["TRETJapanNFCReader-FeliCa-Nanaco"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Nanaco",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Nanaco")
)


// MARK: - FeliCa-NTasu
// エヌタスTカード
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-NTasu",
        targets: ["TRETJapanNFCReader-FeliCa-NTasu"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-NTasu",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/NTasu")
)


// MARK: - FeliCa-Octopus
// 八達通 / Octopus
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Octopus",
        targets: ["TRETJapanNFCReader-FeliCa-Octopus"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Octopus",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Octopus")
)


// MARK: - FeliCa-Okica
// OKICA
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Okica",
        targets: ["TRETJapanNFCReader-FeliCa-Okica"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Okica",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Okica")
)


// MARK: - FeliCa-RakutenEdy
// 楽天Edy / Rakuten Edy
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-RakutenEdy",
        targets: ["TRETJapanNFCReader-FeliCa-RakutenEdy"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-RakutenEdy",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/RakutenEdy")
)


// MARK: - FeliCa-Ryuto
// りゅーと / Ryuto
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Ryuto",
        targets: ["TRETJapanNFCReader-FeliCa-Ryuto"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Ryuto",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Ryuto")
)


// MARK: - FeliCa-TransitIC
// 交通系IC / Transit IC
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-TransitIC",
        targets: ["TRETJapanNFCReader-FeliCa-TransitIC"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-TransitIC",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/TransitIC")
)


// MARK: - FeliCa-UnivCoopICPrepaid
// 大学生協ICプリペイド / Japanese Univ. Co-op IC Prepaid
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
        targets: ["TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-UnivCoopICPrepaid",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/UnivCoopICPrepaid")
)


// MARK: - FeliCa-Waon
// WAON
products.append(
    .library(
        name: "TRETJapanNFCReader-FeliCa-Waon",
        targets: ["TRETJapanNFCReader-FeliCa-Waon"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-FeliCa-Waon",
        dependencies: ["TRETJapanNFCReader-FeliCa"],
        path: "Sources/FeliCa/Waon")
)


// MARK: - ISO7816-DriversLicense
// 日本の運転免許証 / Japanese Driver's License
products.append(
    .library(
        name: "TRETJapanNFCReader-ISO7816-DriversLicense",
        targets: ["TRETJapanNFCReader-ISO7816-DriversLicense"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-ISO7816-DriversLicense",
        dependencies: [
            "TRETJapanNFCReader-ISO7816"
        ],
        path: "Sources/ISO7816/DriversLicense")
)


// MARK: - ISO7816-IndividualNumber
// 個人番号カード（マイナンバーカード） / Japanese Individual Number Card (My Number Card)
products.append(
    .library(
        name: "TRETJapanNFCReader-ISO7816-IndividualNumber",
        targets: ["TRETJapanNFCReader-ISO7816-IndividualNumber"])
)
targets.append(
    .target(
        name: "TRETJapanNFCReader-ISO7816-IndividualNumber",
        dependencies: [
            "TRETJapanNFCReader-ISO7816"
        ],
        path: "Sources/ISO7816/IndividualNumber")
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
