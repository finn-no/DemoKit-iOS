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
        .package(url: "https://github.com/pimms/swift-snapshot-testing.git", exact: "1.9.666"),
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
