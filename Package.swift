// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "DemoKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "DemoKit", targets: ["DemoKit"]),
        .library(name: "DemoKitSnapshot", targets: ["DemoKitSnapshot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", exact: "1.15.1"),
    ],
    targets: [
        .target(name: "DemoKit"),
        .target(
            name: "DemoKitSnapshot",
            dependencies: [
                "DemoKit",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
