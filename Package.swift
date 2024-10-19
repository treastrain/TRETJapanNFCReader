// swift-tools-version: 6.0

import PackageDescription

let packageName = "TRETNFCKit"

extension SwiftSetting {
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                      // SE-0335, Swift 5.6,  SwiftPM 5.8+
    static let internalImportsByDefault: Self = .enableUpcomingFeature("InternalImportsByDefault")  // SE-0409, Swift 6.0,  SwiftPM 6.0+
}

let swiftSettings: [SwiftSetting] = [
    .existentialAny,
    .internalImportsByDefault,
]

var products: [Product] = []
var targets: [Target] = []

@discardableResult
@MainActor func add(moduleName: String, dependencies: [Target.Dependency] = [], includesTest: Bool, swiftLanguageMode: SwiftLanguageMode) -> Target.Dependency {
    let targetName = "\(packageName)_\(moduleName)"
    let target = Target.Dependency(stringLiteral: targetName)
    products.append(
        .library(name: targetName, targets: [targetName])
    )
    let swiftSettings = swiftSettings + [.swiftLanguageMode(swiftLanguageMode)]
    targets.append(
        .target(name: targetName, dependencies: dependencies, path: "Sources/\(moduleName)", swiftSettings: swiftSettings)
    )
    if includesTest {
        targets.append(
            .testTarget(name: "\(packageName).\(moduleName)Tests", dependencies: [target], path: "Tests/\(moduleName)Tests", swiftSettings: swiftSettings)
        )
    }
    return target
}

// MARK: - Modules - Tools for DEBUG
let assertServices = add(moduleName: "AssertServices", includesTest: false, swiftLanguageMode: .v6)
let infoPListChecker = add(moduleName: "InfoPListChecker", includesTest: false, swiftLanguageMode: .v6)

// MARK: - Modules - Primary
let core = add(moduleName: "Core", dependencies: [assertServices, infoPListChecker], includesTest: false, swiftLanguageMode: .v6)
let nativeTag = add(moduleName: "NativeTag", dependencies: [core], includesTest: false, swiftLanguageMode: .v6)
add(moduleName: "NDEFMessage", dependencies: [core], includesTest: false, swiftLanguageMode: .v6)
add(moduleName: "NDEFTag", dependencies: [core], includesTest: false, swiftLanguageMode: .v6)

// MARK: - Modules - Secondary
add(moduleName: "FeliCa", dependencies: [nativeTag], includesTest: false, swiftLanguageMode: .v6)
add(moduleName: "ISO7816", dependencies: [nativeTag], includesTest: false, swiftLanguageMode: .v6)
add(moduleName: "ISO15693", dependencies: [nativeTag], includesTest: false, swiftLanguageMode: .v6)
add(moduleName: "MiFare", dependencies: [nativeTag], includesTest: false, swiftLanguageMode: .v6)

// MARK: - Package
products.append(
    .library(name: packageName, targets: [packageName])
)
targets.append(
    .target(name: packageName, dependencies: targets.filter { !$0.isTest }.map { .init(stringLiteral: $0.name) }, swiftSettings: swiftSettings)
)

let package = Package(
    name: packageName,
    defaultLocalization: "en",
    platforms: [.iOS(.v13), .macOS(.v10_15), .macCatalyst(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: products,
    targets: targets
)
