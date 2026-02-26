// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Libraries",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library("Libraries"),
        .library("ExternalDependencies"),
        .library("AppFeature"),
        .library("CharcoalUI"),
        .library("MaterialUI"),
        .library("SBBUI"),
    ],
    dependencies: [
        // Centralizing third-party libraries
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.25.2"),
        .package(url: "https://github.com/pixiv/charcoal-ios.git", .upToNextMajor(from: "2.2.2")),
        .package(url: "https://github.com/lipzh-yzr/MaterialUIKit.git", from: "2.0.2"),
        .package(url: "https://github.com/SchweizerischeBundesbahnen/mobile-ios-design-swiftui.git", .upToNextMajor(from: "1.2.8"))
    ],
    targets: targets
)

var targets: [Target] {
    [
        .target(
            name: "Libraries"
        ),
        .target(
            name: "ExternalDependencies",
            dependencies: [.tca]
        ),
        .target(
            name: "AppFeature",
            dependencies: ["ExternalDependencies"]
        ),
        .target(
            name: "CharcoalUI",
            dependencies: [.charcoal]
        ),
        .testTarget(
            name: "CharcoalUITests",
            dependencies: ["CharcoalUI"]
        ),
        .target(
            name: "MaterialUI",
            dependencies: [.materialUIKit]
        ),
        .testTarget(
            name: "MaterialUITests",
            dependencies: ["MaterialUI"]
        ),
        .target(
            name: "SBBUI",
            dependencies: [.sbbDesignSystem]
        ),
        .testTarget(
            name: "SBBUITests",
            dependencies: ["SBBUI"]
        ),
    ]
}

extension Target.Dependency {
    static var tca: Self { .product(name: "ComposableArchitecture", package: "swift-composable-architecture") }
    static var charcoal: Self { .product(name: "Charcoal", package: "charcoal-ios") }
    static var materialUIKit: Self { .product(name: "MaterialUIKit", package: "MaterialUIKit") }
    static var sbbDesignSystem: Self { .product(name: "SBBDesignSystemMobileSwiftUI", package: "mobile-ios-design-swiftui") }
}

extension Product {
    static func library(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
