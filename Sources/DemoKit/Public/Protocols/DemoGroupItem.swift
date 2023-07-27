import Foundation

/// Represents a demo for a single item within a `DemoGroup`.
public protocol DemoGroupItem {
    var groupItemIdentifier: String { get }
    var groupItemTitle: String { get }
}

// MARK: - Default values

public extension DemoGroupItem where Self: RawRepresentable, RawValue == String {
    var groupItemIdentifier: String {
        rawValue
    }

    var groupItemTitle: String {
        rawValue.capitalizingFirstLetter
    }
}
