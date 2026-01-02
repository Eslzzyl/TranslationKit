// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Translate",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Translate",
            targets: ["Translate"]
        ),
    ],
    targets: [
        .target(
            name: "Translate",
            dependencies: [],
            path: "Sources/Translate"
        ),
        .testTarget(
            name: "TranslateTests",
            dependencies: ["Translate"],
            path: "Tests/TranslateTests"
        ),
    ]
)
