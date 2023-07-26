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
        .package(url: "https://github.com/pimms/swift-snapshot-testing.git", revision: "b44b563e6ddc5a613a107fb57626047a7f1d4e1a"),
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
