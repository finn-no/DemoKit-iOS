import Foundation

/// Represents a demo for a single item within a `DemoGroup`.
@MainActor
public protocol DemoGroupItem {
    var groupItemTitle: String { get }
}

// MARK: - Default values

public extension DemoGroupItem where Self: RawRepresentable, RawValue == String {
    var groupItemTitle: String {
        rawValue.capitalizingFirstLetter
    }
}
