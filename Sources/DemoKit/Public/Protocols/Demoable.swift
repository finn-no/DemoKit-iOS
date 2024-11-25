import Foundation
import UIKit

/// A single item that can be demoed. Conform to this protocol to make your type demoable.
/// Supported types are listed in `ViewControllerMapper` where an appropriate `UIViewController` will be created and configured.
@MainActor
public protocol Demoable {
    /// Use to identify this specific demo when snapshotting. The value of `identifier` will be used for the snapshot reference image name.
    /// Defaults to the stringified name of the demo type.
    var identifier: String { get }
    /// String to present within navigation bar when navigating to this demo.
    /// Defaults to the stringified name of the demo type.
    var title: String { get }
    
    /// Return `true` for this property if your `Demoable` is a `UIViewController`, and you want to control `modalPresentationStyle` from that view controller.
    /// Defaults to `false`.
    var overridesModalPresentationStyle: Bool { get }
    /// Defines how this demo can be dismissed.
    /// Defaults to `doubleTap`.
    var dismissKind: DismissKind { get }
    /// Defines how this demo will be presented.
    /// Defaults to `.none`, which will present using a plain `UIViewController` with `UIModalPresentationStyle.fullScreen`.
    var presentation: DemoablePresentation { get }
    
    /// List of buttons on left side when `presentation` is `navigationController`.
    /// Defaults to an empty array.
    var leftBarButtonItems: [UIBarButtonItem] { get }
    /// List of buttons on right side when `presentation` is `navigationController`.
    /// Defaults to an empty array.
    var rightBarButtonItems: [UIBarButtonItem] { get }
    
    /// Defines whether or not this demo should be included when running shapshot tests.
    /// Defaults to `true`.
    var shouldSnapshotTest: Bool { get }
}

// MARK: - Default values

/// Default values for the protocol.
public extension Demoable {
    var identifier: String { String(describing: Self.self) }
    var title: String { String(describing: Self.self) }

    var overridesModalPresentationStyle: Bool { false }
    var dismissKind: DismissKind { .doubleTap }
    var presentation: DemoablePresentation { .none }

    var leftBarButtonItems: [UIBarButtonItem] { [] }
    var rightBarButtonItems: [UIBarButtonItem] { [] }

    var shouldSnapshotTest: Bool { true }
}
