// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-helpers",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .library(name: "SwiftHelpers", targets: ["SwiftHelpers"]),
        .library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-prelude", .branch("main")),
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
    ],
    targets: [
        .target(
            name: "SwiftHelpers",
            dependencies: [
                .product(name: "Prelude", package: "swift-prelude"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "SwiftUIHelpers",
            dependencies: [
                .target(name: "SwiftHelpers"),
            ]
        ),
    ]
)
