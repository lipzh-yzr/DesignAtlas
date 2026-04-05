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
        .library("Utils"),
        .library("CommonDefines"),
        .library("ServiceInterface"),
        .library("RepositoryService"),
        .library("SystemShowcase"),
        .library("AppFeature"),
        .library("CharcoalUI"),
        .library("MaterialUI"),
        .library("SBBUI"),
        .library("StructuraUI"),
        .library("RatingFeature"),
    ],
    dependencies: [
        // Centralizing third-party libraries
        .package(url: "https://github.com/hmlongco/Factory", exact: "2.5.3"),
        .package(url: "https://github.com/pixiv/charcoal-ios.git", .upToNextMajor(from: "2.2.2")),
        .package(url: "https://github.com/lipzh-yzr/MaterialUIKit.git", from: "2.0.2"),
        .package(url: "https://github.com/SchweizerischeBundesbahnen/mobile-ios-design-swiftui.git", .upToNextMajor(from: "1.2.8")),
        .package(url: "https://github.com/lipzh-yzr/Structura-design-system-swiftui.git", from: "0.1.0")
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
            dependencies: [.factory],
            path: "Sources/Foundations/ExternalDependencies"
        ),
        .target(
            name: "Utils",
            dependencies: ["ExternalDependencies"],
            path: "Sources/Foundations/Utils"
        ),
        .target(
            name: "CommonDefines",
            path: "Sources/FeatureSupport/CommonDefines"
        ),
        .target(
            name: "ServiceInterface",
            dependencies: ["CommonDefines"],
            path: "Sources/Service/ServiceInterface"
        ),
        .target(
            name: "RepositoryService",
            dependencies: ["ServiceInterface"],
            path: "Sources/Service/RepositoryService"
        ),
        .target(
            name: "SystemShowcase",
            path: "Sources/Features/SystemShowcase"
        ),
        .target(
            name: "AppFeature",
            dependencies: ["ExternalDependencies",
                           "Utils"],
            path: "Sources/Features/AppFeature"
        ),
        .target(
            name: "CharcoalUI",
            dependencies: [.charcoal,
                           "Utils"],
            path: "Sources/Features/CharcoalUI"
        ),
        .testTarget(
            name: "CharcoalUITests",
            dependencies: ["CharcoalUI"]
        ),
        .target(
            name: "MaterialUI",
            dependencies: [.materialUIKit,
                           "Utils"],
            path: "Sources/Features/MaterialUI"
        ),
        .testTarget(
            name: "MaterialUITests",
            dependencies: ["MaterialUI"]
        ),
        .target(
            name: "SBBUI",
            dependencies: [.sbbDesignSystem,
                           "Utils"],
            path: "Sources/Features/SBBUI"
        ),
        .testTarget(
            name: "SBBUITests",
            dependencies: ["SBBUI"]
        ),
        .target(
            name: "StructuraUI",
            dependencies: [.structuraDesignSystem,
                           "Utils"],
            path: "Sources/Features/StructuraUI"
        ),
        .target(
            name: "RatingFeature",
            dependencies: ["CommonDefines"],
            path: "Sources/Features/RatingFeature"
        ),
        .testTarget(
            name: "RatingFeatureTests",
            dependencies: ["RatingFeature"]
        ),
    ]
}

extension Target.Dependency {
    static var factory: Self { .product(name: "Factory", package: "Factory") }
    static var charcoal: Self { .product(name: "Charcoal", package: "charcoal-ios") }
    static var materialUIKit: Self { .product(name: "MaterialUIKit", package: "MaterialUIKit") }
    static var sbbDesignSystem: Self { .product(name: "SBBDesignSystemMobileSwiftUI", package: "mobile-ios-design-swiftui") }
    static var structuraDesignSystem: Self { .product(name: "StructuraSwiftUI", package: "Structura-design-system-swiftui") }
}

extension Product {
    static func library(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
