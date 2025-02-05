// swift-tools-version: 5.9

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
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", exact: "1.18.0")
    ],
    targets: [
        .target(
            name: "DemoKit",
            swiftSettings: .strictConcurrency
        ),
        .target(
            name: "DemoKitSnapshot",
            dependencies: [
                "DemoKit",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            swiftSettings: .strictConcurrency
        )
    ]
)

// https://forums.swift.org/t/concurrency-checking-in-swift-packages-unsafeflags/61135/14
// https://github.com/apple/swift/pull/66991
@available(swift, deprecated: 6.0, message: "Strict concurrency should be enabled by default in Swift 6")
extension Array where Element == SwiftSetting {
    static var strictConcurrency: [SwiftSetting] {
        [SwiftSetting.enableExperimentalFeature("StrictConcurrency")]
    }
}
