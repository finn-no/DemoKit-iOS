import Foundation

/// Represents a demo for a single item within a `DemoGroup`.
public protocol DemoGroupItem {
    var identifier: String { get }
    var title: String { get }
}

// MARK: - Default values

public extension DemoGroupItem where Self: RawRepresentable, RawValue == String {
    var identifier: String {
        rawValue
    }

    var title: String {
        rawValue.capitalizingFirstLetter
    }
}
