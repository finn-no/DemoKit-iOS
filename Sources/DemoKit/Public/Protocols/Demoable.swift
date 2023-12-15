import Foundation
import UIKit

/// A single item that can be demoed.
@MainActor
public protocol Demoable {
    var identifier: String { get }
    var title: String { get }

    var overridesModalPresentationStyle: Bool { get }
    var dismissKind: DismissKind { get }
    var presentation: DemoablePresentation { get }

    var leftBarButtonItems: [UIBarButtonItem] { get }
    var rightBarButtonItems: [UIBarButtonItem] { get }

    var shouldSnapshotTest: Bool { get }
}

// MARK: - Default values

public extension Demoable {
    var identifier: String {
        String(describing: Self.self)
    }

    var title: String {
        String(describing: Self.self)
    }

    var overridesModalPresentationStyle: Bool { false }
    var dismissKind: DismissKind { .doubleTap }
    var presentation: DemoablePresentation { .none }

    var leftBarButtonItems: [UIBarButtonItem] { [] }
    var rightBarButtonItems: [UIBarButtonItem] { [] }

    var shouldSnapshotTest: Bool { true }
}
