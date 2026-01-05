// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "TranslationKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "TranslationKit",
            targets: ["TranslationKit"]
        ),
    ],
    targets: [
        .target(
            name: "TranslationKit",
            dependencies: [],
            path: "Sources/TranslationKit"
        ),
        .testTarget(
            name: "TranslationKitTests",
            dependencies: ["TranslationKit"],
            path: "Tests/TranslationKitTests"
        ),
    ]
)
