import Foundation
import UIKit

/// Use to setup a group of demo views that are related. I.e. components, colors or views within a specific domain.
@MainActor
public protocol DemoGroup {
    /// Returns how many individual demos does this group contain.
    static var numberOfDemos: Int { get }
    /// The title for this demo group. Will be shown in the group selector within the `UINavigationBar` in `DemoViewController`.
    /// Defaults to a stringified version of self.
    static var groupTitle: String { get }
    
    /// Get the presentation info for a demo within this group. Used when listing demos within this group.
    /// - Parameter index: The index for the demo. Will be a value between `0 ..< numberOfDemos`.
    /// - Returns: A `DemoGroupItem`.
    static func demoGroupItem(for index: Int) -> any DemoGroupItem

    /// Get the demoable for a demo within this group. Used when the user selects a demo within the list of demos in this group.
    /// - Parameter index: The index for the `Demoable`. Will be a value between `0 ..< numberOfDemos`.
    /// - Returns: A `Demoable`.
    static func demoable(for index: Int) -> any Demoable
}

// MARK: - Default values

public extension DemoGroup {
    static var groupTitle: String {
        String(describing: Self.self)
    }
}
