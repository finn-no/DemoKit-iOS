import Foundation
import UIKit

/// Use to setup a group of demo views that are related. I.e. components, colors or views within a specific domain.
@MainActor
public protocol DemoGroup {
    static var numberOfDemos: Int { get }
    static var groupTitle: String { get }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem
    static func demoable(for index: Int) -> any Demoable
}

// MARK: - Default values

public extension DemoGroup {
    static var groupTitle: String {
        String(describing: Self.self)
    }
}
