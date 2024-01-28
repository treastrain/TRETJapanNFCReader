// swift-tools-version: 5.9

import PackageDescription

let packageName = "TRETNFCKit"

extension SwiftSetting {
    static let forwardTrailingClosures: Self = .enableUpcomingFeature("ForwardTrailingClosures")
    static let strictConcurrency: Self = .enableUpcomingFeature("StrictConcurrency")
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")
    static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")
    static let conciseMagicFile: Self = .enableUpcomingFeature("ConciseMagicFile")
    static let importObjcForwardDeclarations: Self = .enableUpcomingFeature("ImportObjcForwardDeclarations")
    static let disableOutwardActorInference: Self = .enableUpcomingFeature("DisableOutwardActorInference")
}

let swiftSettings: [SwiftSetting] = [
    .forwardTrailingClosures,
    .strictConcurrency,
    .existentialAny,
    .bareSlashRegexLiterals,
    .conciseMagicFile,
    .importObjcForwardDeclarations,
    .disableOutwardActorInference,
]

var products: [Product] = []
var targets: [Target] = []

@discardableResult
func add(moduleName: String, dependencies: [Target.Dependency] = [], includesTest: Bool) -> Target.Dependency {
    let targetName = "\(packageName)_\(moduleName)"
    let target = Target.Dependency(stringLiteral: targetName)
    products.append(
        .library(name: targetName, targets: [targetName])
    )
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
let assertServices = add(moduleName: "AssertServices", includesTest: false)
let infoPListChecker = add(moduleName: "InfoPListChecker", includesTest: false)

// MARK: - Modules - Primary
let async = add(moduleName: "Async", includesTest: false)
let core = add(moduleName: "Core", dependencies: [assertServices, infoPListChecker], includesTest: true)
let nativeTag = add(moduleName: "NativeTag", dependencies: [core], includesTest: true)
add(moduleName: "NDEFMessage", dependencies: [core], includesTest: true)
add(moduleName: "NDEFTag", dependencies: [core], includesTest: true)

// MARK: - Modules - Secondary
add(moduleName: "FeliCa", dependencies: [nativeTag], includesTest: true)
add(moduleName: "ISO7816", dependencies: [nativeTag], includesTest: true)
add(moduleName: "ISO15693", dependencies: [nativeTag], includesTest: true)
add(moduleName: "MiFare", dependencies: [nativeTag], includesTest: true)

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
