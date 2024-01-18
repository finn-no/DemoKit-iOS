import XCTest
import UIKit
import SwiftUI
@testable import DemoKit
import SnapshotTesting

// MARK: - DemoGroup

extension XCTestCase {
    @MainActor
    public func snapshotTest(
        demoGroup: any DemoGroup.Type,
        record: Bool = false,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        for demoableIndex in (0..<demoGroup.numberOfDemos) {
            let demoable = demoGroup.demoable(for: demoableIndex)

            snapshotTest(
                demoable: demoable,
                record: record,
                file: file,
                line: line
            )
        }
    }
}

// MARK: - Demoable

extension XCTestCase {
    @MainActor
    public func snapshotTest(
        demoable: any Demoable,
        record: Bool = false,
        // https://github.com/pointfreeco/swift-snapshot-testing/pull/628#issuecomment-1256363278
        precision: Float = 1,
        perceptualPrecision: Float = 0.98,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard demoable.shouldSnapshotTest else { return }

        let viewController = ViewControllerMapper.viewController(for: demoable)
        viewController.view.layoutIfNeeded()

        if let tweakableDemo = demoable as? TweakableDemo, tweakableDemo.shouldSnapshotTweaks, tweakableDemo.numberOfTweaks > 0 {
            for tweakIndex in (0..<tweakableDemo.numberOfTweaks) {
                let tweak = tweakableDemo.tweak(for: tweakIndex)
                tweakableDemo.configure(forTweakAt: tweakIndex)

                performSnapshots(
                    viewController: viewController,
                    record: record,
                    testName: demoable.identifier, 
                    tweakName: tweak.testName,
                    precision: precision,
                    perceptualPrecision: perceptualPrecision,
                    file: file,
                    line: line
                )
            }
        } else {
            performSnapshots(
                viewController: viewController,
                record: record,
                testName: demoable.identifier,
                precision: precision,
                perceptualPrecision: perceptualPrecision,
                file: file,
                line: line
            )
        }
    }
}

// MARK: - SwiftUI

extension XCTestCase {
    @MainActor
    public func snapshotTest(
        view: any View,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let hostingViewController = UIHostingController(rootView: AnyView(view))

        snapshotTest(
            viewController: hostingViewController,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
}

// MARK: - UIView and UIViewController

extension XCTestCase {
    @MainActor
    public func snapshotTest(
        uiView: UIView,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let viewController = UIViewController()
        viewController.view.addSubview(uiView)
        uiView.fillInSuperview()

        snapshotTest(
            viewController: viewController,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }

    @MainActor
    public func snapshotTest(
        viewController: UIViewController,
        record: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        // This is needed to do the initial layout.
        viewController.view.layoutIfNeeded()

        performSnapshots(
            viewController: viewController,
            record: record,
            testName: testName,
            file: file,
            line: line
        )
    }
}

// MARK: - Internal methods

extension XCTestCase {
    @MainActor
    func performSnapshots(
        viewController: UIViewController,
        record: Bool,
        testName: String,
        tweakName: String? = nil,
        precision: Float = 1,
        perceptualPrecision: Float = 0.98,
        file: StaticString,
        line: UInt
    ) {
        UIView.setAnimationsEnabled(false)
        let userInterfaceStyle: [UIUserInterfaceStyle] = [.light, .dark]

        userInterfaceStyle.forEach { userInterfaceStyle in
            SnapshotDevice.allCases.forEach { device in
                let name = [userInterfaceStyle.description, device.name, tweakName].compactMap { $0 }.joined(separator: "_")

                let traits = UITraitCollection(traitsFrom: [
                    UITraitCollection(userInterfaceStyle: userInterfaceStyle),
                    UITraitCollection(horizontalSizeClass: device.horizontalSizeClass)
                ])

                assertSnapshot(
                    matching: viewController,
                    as: .image(
                        on: device.imageConfig,
                        precision: precision,
                        perceptualPrecision: perceptualPrecision,
                        traits: traits
                    ),
                    named: name,
                    record: record,
                    file: file,
                    testName: testName,
                    line: line
                )
            }
        }
    }
}

// MARK: - Private types

enum SnapshotDevice: CaseIterable {
    case iPad
    case iPhone

    var imageConfig: ViewImageConfig {
        switch self {
        case .iPad:
            return .iPadPro12_9
        case .iPhone:
            return .iPhoneX
        }
    }

    var horizontalSizeClass: UIUserInterfaceSizeClass {
        switch self {
        case .iPad:
            return .regular
        case .iPhone:
            return .compact
        }
    }

    var name: String {
        switch self {
        case .iPad:
            return "iPad"
        case .iPhone:
            return "iPhone"
        }
    }
}

// MARK: - Private extensions

extension TweakingOption {
    var testName: String {
        // Only allow alphanumeric characters in test name.
        let pattern = "[^A-Za-z0-9]+"
        return identifier.lowercased().replacingOccurrences(of: pattern, with: "-", options: [.regularExpression])
    }
}
