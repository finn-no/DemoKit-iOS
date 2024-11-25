import Foundation
import UIKit

/// Defines how a `Demoable` should be presented.
@MainActor
public enum DemoablePresentation {
    /// Use a default presentation, aka. full screen.
    case none
    /// Present within a sheet using the detents provided.
    case sheet(detents: [UISheetPresentationController.Detent])
    /// Present within a `UINavigationController`.
    case navigationController
}
