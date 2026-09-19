// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ProjectLocale",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ProjectLocale",
            targets: ["ProjectLocale"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ProjectLocale",
            path: "ProjectLocale.xcframework"
        )
    ]
)
